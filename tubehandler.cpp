#include "channel.h"
#include "tubehandler.h"
#include <QDebug>
#include <QFile>
#include <QDataStream>
#include <QtEndian>
#include <QtMath>
#include <QPointF>
#include <iostream>
#include <fstream>

#ifdef WIN32
#include "winsock2.h"
#else
#include <arpa/inet.h>
#endif
static void fixHdr( TubeHeader *h);

TubeHandler::TubeHandler(QObject *parent) : QObject(parent),
    m_chan(nullptr),
    tubeFile(QString())
{
    m_scale = 1;
    m_cursorWidth = 0;
    m_expTp = 0;
    qDebug() << "Tube handler init";
}

TubeHandler::~TubeHandler()
{

}

QString TubeHandler::getTubeFile()
{
    return tubeFile;
}

int TubeHandler::getScale() const
{
    return m_scale;
}

void TubeHandler::setScale(const int scale)
{
    if(m_scale != scale){
        m_scale = scale;
        Q_EMIT scaleChanged();
    }
}

int TubeHandler::getStripWidth() const
{
    return m_stripWidth;
}

void TubeHandler::setStripWidth(const int width)
{
    if(m_stripWidth != width){
        m_stripWidth = width;
        Q_EMIT stripWidthChanged();
    }
}

int TubeHandler::getStripHeight() const
{
    return m_stripHeight;
}

void TubeHandler::setStripHeight(const int height)
{
    if(m_stripHeight != height){
        m_stripHeight = height;
        Q_EMIT stripHeightChanged();
    }
}

int TubeHandler::getCursorWidth() const
{
    return m_cursorWidth;
}

inline int stripY(const int hs, const int tp, const int pt, const int scale)
{
    int y = (hs - 1) - (pt - tp)/scale;
    return y;
}

inline int stripPoint(const int y, const int height, const int scale){
    int sc_tp = 0;// temporary set sc_tp = 0
    int pt  = sc_tp + (height-1-y) * scale;
    return pt;
}

static int formatBuff(TubeData *tube, char *buff,int nbyte)
{
    int n=0;
    short *p,*q;

    p = (short*) buff;
    q = p + nbyte/2;

    static int ch = 0;
    static int last = 0;
    while(p < q)
    {
        short x = htons(*p++);
        short y = htons(*p++);

        if(tube->channels.find(ch) == tube->channels.end()){
            Channel chanObj(QString::number(ch)); //Temporarily set channel name equals to chanOrder
            chanObj.add(x, y);
            tube->channels[ch] = chanObj;
        }else{
            Channel& chanObj = tube->channels[ch];
            chanObj.add(x, y);
        }

        if(++ch == tube->nraw)
        {
            ch = 0;
            n++;
            if(++last >= tube->npt) last = 0;
        }
    }

    return(n);
}


int TubeHandler::getDrawPointList(const int chan,
                                  const int xavg_p)
{
    Q_ASSERT(!m_tube.isNull() || m_tube->channels.find(chan) != m_tube->channels.end());
    qDebug() << "Chan idx:" << chan << " Xvag_point: " << xavg_p << " Width: " << m_stripWidth << " height: " << m_stripHeight;
    int j;
    int cent,x0,x,xmax,xmin;
    int a,b,c;
    short vxavg,vyavg;
    int pix;
    int pt0;
    vxavg = vyavg = 0;
    const int scaleMax = maxScale(m_stripHeight);
    if(m_scale > scaleMax) m_scale = scaleMax;
    pt0 = m_scale * m_stripHeight - 1;

    const int FACTOR = 100;
    float theta = M_PI * 0/180.0;
    const int span = 2784;
    a = -(FACTOR * m_stripWidth * qSin(theta));
    b = FACTOR * m_stripWidth * qCos(theta);
    c = FACTOR * span;

    Channel& channel = m_tube->channels[chan];

    //cal xavg point
    int dpt = stripPoint(xavg_p, m_stripHeight, m_scale);
    if(dpt < 0 || dpt >= channel.getData().size()){ //invalid dpt then calculate avg data
        calAvgData(channel, vxavg, vyavg);
    }else{
       const QPoint& data = channel.at(dpt);
       vxavg = static_cast<short>(data.x());
       vyavg = static_cast<short>(data.y());
    }
    ChannelParam& cp = channel.getCp();
    cp.xavg = vxavg;
    cp.yavg = vyavg;
    pix = 0;
    cent = m_stripWidth/2;

    if(pt0 >= 0 && pt0 < m_tube->npt)
        {
        x0 = cent + (a*(channel.at(pt0).x()-vxavg) + b*(channel.at(pt0).y()-vyavg))/c;
        }
    else
        x0 = cent;
    pt0--;
/* move to first point */

    points.clear();
    points.push_back(QPoint(x0, pix));

    while(pix < m_stripHeight)
        {
/* find the min and max on this pixel */
        x = xmin = xmax = x0;
        for(j = 1; j < m_scale; ++j)
            {
            if(pt0 >= 0 && pt0 < m_tube->npt)
                {
                x = cent + (a*(channel.at(pt0).x()-vxavg) + b*(channel.at(pt0).y()-vyavg))/c;
                }
            else
                x = cent;
            pt0--;
            if(x < xmin)
                xmin = x;
            else if(x > xmax)
                xmax = x;
            }

        if(pt0 >= 0 && pt0 < m_tube->npt)
            {
            x0 = cent + (a*(channel.at(pt0).x()-vxavg) + b*(channel.at(pt0).y()-vyavg))/c;
            }
        else
            x0 = cent;

        pt0--;
        points.push_back(QPoint(xmin, pix));
        points.push_back(QPoint(xmax, pix));
        points.push_back(QPoint(x, pix));
        points.push_back(QPoint(x0, ++pix));

    }
    qDebug() << "Size of point array: " << points.size();
    return points.size();
}

QPoint TubeHandler::getPoint(const int i)
{
    if(i < 0 || i >= points.size()) return QPoint(0, 0);
    return points[i];
}

QPoint TubeHandler::getExpPoint(const int i)
{
    if(i < 0 || i >= ePoints.size()) return QPoint(0, 0);
    return ePoints[i];
}

QPoint TubeHandler::getLissPoint(const int i)
{
    if(i < 0 || i >= lPoints.size()) return QPoint(0, 0);
    return lPoints[i];
}

int TubeHandler::maxScale(const int height) const
{
    if (m_tube.data()) {
        return m_tube->raw_npt/height;
    }
    return -1;
}

int TubeHandler::getCursorWidth(const int currentPix, const int expWidth)
{

    int center = stripPoint(currentPix, m_stripHeight, m_scale);

    int expTp = center - expWidth/2;

    int cymin = stripY(m_stripHeight, 0, expTp+expWidth-1, m_scale);
    int cymax = stripY(m_stripHeight, 0, expTp, m_scale);
    m_cursorWidth = abs(cymax - cymin);
    Q_EMIT cursorWidthChanged();
    qDebug() << "m_cursorWidth = " << m_cursorWidth;
    return m_cursorWidth;
}

int TubeHandler::pixToDpt(const int pix)
{
    return stripPoint(pix, m_stripHeight, m_scale);
}

int TubeHandler::calExpPoints(const int chan, bool leftside)
{
    int k;
    short base;
    int a,b,c,vxavg,vyavg,cent;
    int vx,vy,pnt;
    int x1, y1;

    if(m_expHeight < 2)
        return 0;
    if(m_tube.data() == nullptr ||
       m_tube->channels.find(chan) == m_tube->channels.end())
    {
        return 0;
    }

    /* get raw data pointers */
    Channel& channel = m_tube->channels[chan];
    ChannelParam& cp = channel.getCp();
    if(cp.xavg == 0){
        calAvgData(channel, cp.xavg, cp.yavg);
    }
    vxavg = cp.xavg;
    vyavg = cp.yavg;


    /* get transformation coefficients */
    const int FACTOR = 100;
    float theta = M_PI * 0/180.0;
    const int span = 2784;
    a = FACTOR * m_expWidth * cos(theta);
    b = FACTOR * m_expWidth * sin(theta);
    c = FACTOR * span;

    cent = m_expWidth/2;
    if (c==0) c=1;

    /* setup y coordinates */
    base = (m_expHeight-1);
    pnt = m_expTp;
    ePoints.clear();
    for(k = 0; k < m_expHeight; ++k){
        y1 = base--;
        vx = channel.at(pnt).x() - vxavg;
        vy = channel.at(pnt).y() - vyavg;
        if(leftside){
            x1 = cent + (-b*vx + a*vy)/c;
        }else {
            x1 = cent + (a*vx + b*vy)/c;
        }
        ePoints.push_back(QPoint(x1, y1));
        if(++pnt >= m_tube->raw_npt) pnt = 0;
    }
    return ePoints.size();
}

int TubeHandler::calLissPoints(const int chan)
{
    register int k;
    int a,b,c,xcent,ycent;
    int vx,vy,vxavg,vyavg;
    int x1, y1;
    if(m_Npt < 2)
        return 0;
    if(m_tube.data() == nullptr ||
       m_tube->channels.find(chan) == m_tube->channels.end())
    {
        return 0;
    }
    /* get raw data pointers */
    Channel& channel = m_tube->channels[chan];
    ChannelParam& cp = channel.getCp();
    if(cp.xavg == 0){
        calAvgData(channel, cp.xavg, cp.yavg);
    }
    vxavg = cp.xavg;
    vyavg = cp.yavg;
    /* get transformation coefficients */
    const int FACTOR = 100;
    float theta = M_PI * 0/180.0;
    const int span = 2784;
    a = FACTOR * m_lissWidth * cos(theta);
    b = FACTOR * m_lissWidth * sin(theta);
    c = FACTOR * span;

    if( c==0) c=1;
    xcent = m_lissWidth/2;
    ycent = m_lissHeight/2;

    /* find points (NOTE: positive y axis points downward) */
    int pt0 = m_Pt0;



    // preset points for XDrawLine routine


    lPoints.clear();
    for(k = 0; k < m_Npt; ++k)
    {
        if(++pt0 >= m_tube->npt) pt0=0;

        vx = channel.at(pt0).x() - vxavg;
        vy = channel.at(pt0).y() - vyavg;
        x1 = xcent + (a*vx + b*vy)/c;
        y1 = ycent + (b*vx - a*vy)/c;
        lPoints.push_back(QPoint(x1, y1));
    }

    return lPoints.size();
}


void TubeHandler::setTubeFile(const QString &path)
{
    tubeFile = path;
}


bool TubeHandler::loadTube()
{

    if(tubeFile.isEmpty()){
        qDebug() << "Cannot load tube because tube file is empty";
        return false;
    }
    qDebug() << "Start load the tube file " << tubeFile;

    char buff[READ_SIZE];

    QFile file(tubeFile);
    if(file.open(QIODevice::ReadOnly) == false){
        qDebug() << "Could not load tube file";
        return false;
    }
    m_tube.reset(new TubeData);
    QDataStream in(&file);
    const int length = 1024;
    int count = in.readRawData(buff, length);

    memcpy(&m_tube->hdr, buff, length);

    if((count = sizeHeader( &m_tube->hdr, in)) < 0)
    {
        return false;
    }

    count += length;

    int dataCount = static_cast<int>(file.size()) - count;

    fixHdr(&m_tube->hdr); // convert header to pc format swap bytes
    int npt = dataCount/m_tube->hdr.nbyte;
    initTube(npt);
    qDebug() << "Init tube done";
    int readSize = qMin<int>(READ_SIZE, dataCount);
    int total_samples = 0;
    int total_bytes = 0;

    while((count = in.readRawData(buff, readSize)) > 0 && dataCount > 0)
    {
        total_samples += formatBuff(m_tube.data(), buff, count);

        total_bytes += count;
        dataCount -= count;
        readSize = qMin<int>(READ_SIZE, dataCount);
    }
    qDebug() << "Load tube done";
    QMap<int, Channel>::iterator it = m_tube->channels.begin();

    for(; it != m_tube->channels.end(); it++){
        Channel& ch = it.value();
        int dataSize = ch.getData().size();
        for(int i = dataSize; i < m_tube->npt; i++){
            ch.add(0, 0);
        }
    }
    file.close();
    emit tubeLoaded();
    return true;
}



static void sizeNpt(TubeData*tube)
{
    int n;
    static int npt0 = 0;
    /* determine how many points to allocate */
    if(tube->npt > npt0 || tube->npt < npt0-2*NPT_CHUNK)
        n = tube->npt + NPT_CHUNK;
    else
        n = npt0;
    if(n < MIN_NPT) n=MIN_NPT;
    npt0 = n;
    tube->npt = npt0;
}

int TubeHandler::initTube(const int npt)
{
    const TubeHeader& h = m_tube->hdr;
    m_tube->nraw= h.nchan;
    m_tube->raw_npt = m_tube->npt = npt;
    sizeNpt(m_tube.data());
    return 1;
}

void TubeHandler::calAvgData(const Channel& channel, short &vxavg, short &vyavg) const
{
    for (int i = 0; i < m_tube->raw_npt; i++) {
        const QPoint& data = channel.at(i);
        vxavg += data.x();
        vyavg += data.y();
    }
    vxavg = vxavg/m_tube->raw_npt;
    vyavg = vyavg/m_tube->raw_npt;
}

int TubeHandler::getNpt() const
{
    return m_Npt;
}

void TubeHandler::setNpt(int Npt)
{
    if(m_Npt != Npt){
        m_Npt = Npt;
        Q_EMIT nptChanged();
    }
}

int TubeHandler::getPt0() const
{
    return m_Pt0;
}

void TubeHandler::setPt0(int Pt0)
{
    if(m_Pt0 != Pt0){
        m_Pt0 = Pt0;
        Q_EMIT pt0Changed();
    }
}

int TubeHandler::getLissHeight() const
{
    return m_lissHeight;
}

void TubeHandler::setLissHeight(int lissHeight)
{
    if(m_lissHeight != lissHeight){
        m_lissHeight = lissHeight;
        Q_EMIT lissHeightChanged();
    }
}

int TubeHandler::getLissWidth() const
{
    return m_lissWidth;
}

void TubeHandler::setLissWidth(int lissWidth)
{
    if(m_lissWidth != lissWidth){
        m_lissWidth = lissWidth;
        Q_EMIT lissWidthChanged();
    }
}

int TubeHandler::getExpHeight() const
{
    return m_expHeight;
}

void TubeHandler::setExpHeight(int expHeight)
{
    if(m_expHeight != expHeight){
        m_expHeight = expHeight;
        Q_EMIT expHeightChanged();
    }

}

int TubeHandler::getExpWidth() const
{
    return m_expWidth;
}

void TubeHandler::setExpWidth(int expWidth)
{
    if(m_expWidth != expWidth){
        m_expWidth = expWidth;
        Q_EMIT expWidthChanged();
    }

}

int TubeHandler::getExpTp() const
{
    return m_expTp;
}

void TubeHandler::setExpTp(int expTp)
{
    if(m_expTp != expTp){
        m_expTp = expTp;
        Q_EMIT expTpChanged();
    }

}

int TubeHandler::sizeHeader(TubeHeader *hdr, QDataStream &in)
{
    int count;
    int size;
    char * buff = (char *)hdr;
    buff += 1024;
    if(qFromBigEndian<qint32>(hdr->data_ident) != DATA_IDENT)
    {
        qDebug() << "DATA_IDENT bad in tube header data_ident is " << hdr->data_ident << " instead of 0x55550200";
        return -1;
    }

   if ( qFromBigEndian<qint32>(hdr->data_type) == W_ANSER_8_4 ||
         qFromBigEndian<qint32>(hdr->header_size) == sizeof( TubeHeader))
   {
      if ( qFromBigEndian<qint32>(hdr->header_size) == sizeof( TubeHeader) )
      {
         size = sizeof( TubeHeader) - 1024;
         count = in.readRawData(buff,size);

         if(count != size)
         {
            return -1;
         }
      }
      else
      {
         return -1;
      }
      /* ok */
      return count;
   }

    return -1;
}

static void fixHdr( TubeHeader *h)
{
    int i=0;
    extern float ntohf(float);
    h->data_ident = qFromBigEndian<int>(h->data_ident);

    h->tic_time =   qFromBigEndian<int>(h->tic_time);

    h->data_type = qFromBigEndian<int>(h->data_type);
    h->entry_num = qFromBigEndian<int>(h->entry_num);
    h->data_format = qFromBigEndian<int>(h->data_format);
    h->sample_rate = qFromBigEndian<int>(h->sample_rate);
    h->numStd = qFromBigEndian<int>(h->numStd);

    h->id =  qFromBigEndian<int>(h->id);
    h->row = qFromBigEndian<int>(h->row);
    h->col = qFromBigEndian<int>(h->col);


    h->delay =      qFromBigEndian<int>(h->delay);
    h->nParReg = qFromBigEndian<short>(h->nParReg);

    h->trig_channel = qFromBigEndian<short>(h->trig_channel);
    h->probe_num =  qFromBigEndian<short>(h->probe_num);
    h->num_probes = qFromBigEndian<int>(h->num_probes);
    h->nchan =      qFromBigEndian<int>(h->nchan);
    h->nbyte =      qFromBigEndian<int>(h->nbyte);


    h->read_check =  qFromBigEndian<int>(h->read_check);
    h->end =  qFromBigEndian<int>(h->end);



    h->tester_type = qFromBigEndian<int>(h->tester_type);
    for(i=0; i< MAX_CHAN; i++)
    {
        h->chan[i].num =  qFromBigEndian<short>(h->chan[i].num);
        h->chan[i].freq =  qFromBigEndian<short>(h->chan[i].freq);
        h->chan[i].span =  qFromBigEndian<short>(h->chan[i].span);
        h->chan[i].rot =  qFromBigEndian<short>(h->chan[i].rot);
        h->chan[i].coil = qFromBigEndian<short>(h->chan[i].coil);
        h->chan[i].coil_group =  qFromBigEndian<short>(h->chan[i].coil_group);
        h->chan[i].chan_mode = qFromBigEndian<short>(h->chan[i].chan_mode);
        h->chan[i].context = qFromBigEndian<short>(h->chan[i].context);
        h->chanOrder[i] =  qFromBigEndian<int>(h->chanOrder[i]);
    }

    h->ProbeType =  qFromBigEndian<int>(h->ProbeType);
    h->Inspection_Type =  qFromBigEndian<int>(h->Inspection_Type);
    h->AcqDirection =  qFromBigEndian<int>(h->AcqDirection);
    h->AcqFlags =  qFromBigEndian<int>(h->AcqFlags);
    h->base_chan_offset =  qFromBigEndian<int>(h->base_chan_offset);

    h->interpolation =  qFromBigEndian<int>(h->interpolation);
    h->qtyContext =  qFromBigEndian<int>(h->qtyContext);



    // data added for new headers
    h->max_number_channels =  qFromBigEndian<int>(h->max_number_channels);
    h->tester_config_size =  qFromBigEndian<int>(h->tester_config_size);

    for(i=0; i< 48; i++)
        h->ParReg[i]= qFromBigEndian<unsigned short>(h->ParReg[i]);

    for(i=0; i< MaxTest; i++)
    {
        h->ectest[i].axial_speed = qFromBigEndian<float>(h->ectest[i].axial_speed);
        h->ectest[i].rotation_speed = qFromBigEndian<int>(h->ectest[i].rotation_speed);
        h->ectest[i].startScan.specifiedOffset = qFromBigEndian<float>(h->ectest[i].startScan.specifiedOffset);
        h->ectest[i].startAcquire.specifiedOffset = qFromBigEndian<float>(h->ectest[i].startAcquire.specifiedOffset);
        h->ectest[i].endScan.specifiedOffset = qFromBigEndian<float>(h->ectest[i].endScan.specifiedOffset);
        h->ectest[i].endAcquire.specifiedOffset = qFromBigEndian<float>(h->ectest[i].endAcquire.specifiedOffset);
    }
    h->vision_flag = qFromBigEndian<int>(h->vision_flag);

}


