#include "channel.h"
#include "tubehandler.h"
#include "anserglobal.h"
#include <QDebug>
#include <QFile>
#include <QDataStream>
#include <QtEndian>
#include <QtMath>
#include <QPointF>
#include <QDateTime>
#include <iostream>
#include <fstream>

#ifdef WIN32
#include "winsock2.h"
#else
#include <arpa/inet.h>
#endif
static void fixHdr( TubeHeader *h);

TubeHandler::TubeHandler(QObject *parent) : QObject(parent),
    tubeFile(QString(":/data/005021023102.T")),
    m_scale(1)
{
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

int TubeHandler::formatBuff(char *buff,int nbyte)
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

        if(m_tube->channels.find(ch) == m_tube->channels.end()){
            int freq_idx=m_tube->hdr.chan[ch].freq - 1 ;
            QString fullName;
            fullName.sprintf("CH %2d %4d Khz",
                             m_tube->hdr.chanOrder[ch], m_tube->hdr.test[freq_idx].freq);
            ChannelPtr chanObj(new Channel(QString::number(m_tube->hdr.chanOrder[ch]), this)); //Temporarily set channel name equals to chanOrder
            chanObj->setFullName(fullName);
            chanObj->add(x, y);
            m_tube->channels[ch] = chanObj;
        }else{
            Channel *chanObj = m_tube->channels[ch].data();
            chanObj->add(x, y);
        }

        if(++ch == m_tube->nraw)
        {
            ch = 0;
            n++;
            if(++last >= m_tube->npt) last = 0;
        }
    }

    return(n);
}


int TubeHandler::maxScale(const int height) const
{
    if (m_tube.data()) {
        return m_tube->raw_npt/height;
    }
    return -1;
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
        total_samples += formatBuff(buff, count);

        total_bytes += count;
        dataCount -= count;
        readSize = qMin<int>(READ_SIZE, dataCount);
    }
    qDebug() << "Load tube done";
    QMap<int, ChannelPtr>::iterator it = m_tube->channels.begin();

    for(; it != m_tube->channels.end(); it++){
        Channel* ch = it.value().data();
        ch->setRawNpt(m_tube->raw_npt);
        //Update dataset Id to channel in order to support multi-set
        //Use inspected year stored in tube header for dataset id
        int year = QDateTime::fromTime_t(m_tube->hdr.tic_time).date().year();
        ch->setDataSetId(QString::number(year));
        int dataSize = ch->getData().size();
        for(int i = dataSize; i < m_tube->npt; i++){
            ch->add(0, 0);
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


QList<QObject *> TubeHandler::getChannels() const
{
    if(m_tube != nullptr || !m_tube->channels.empty()){
        return QList<QObject*>();
    }
    QList<QObject *> channels;
    QMap<int, ChannelPtr>::iterator it = m_tube->channels.begin();
    for (;it != m_tube->channels.end();++it) {
        Channel *ch = it.value().data();
        channels.push_back(ch);
    }
    return channels;
}

Channel *TubeHandler::getChannel(const int idx) const
{
    if(m_tube == nullptr ||
      m_tube->channels.empty() ||
      idx < 0 ||
      idx >= m_tube->channels.size()){
        return nullptr;
    }
    QMap<int, ChannelPtr>::iterator it = m_tube->channels.begin();
    for (;it != m_tube->channels.end();++it) {
        if(it.key() == idx){
            return it.value().data();
        }
    }
    return nullptr;
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

    for(i=0; i< MIZ70_MAX_FREQS; i++)
    {
        h->test[i].freq  =  htonl(h->test[i].freq);
        h->test[i].coil =  htonl(h->test[i].coil);
    }

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


