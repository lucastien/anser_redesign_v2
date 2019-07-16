#include "stripchartitem.h"
#include "anserglobal.h"
#include <QtMath>
#include <QPainter>

StripChartItem::StripChartItem(QQuickPaintedItem *parent): QQuickPaintedItem (parent),
    m_chanIdx(-1),
    m_scale(1),
    m_avgPoint(0),
    m_multiYearMode(false),
    m_bgrColor("black"),
    m_borderColor("#524d4d")
{

}

int StripChartItem::chanIdx() const
{
    return m_chanIdx;
}

void StripChartItem::setChanIdx(int chanIdx)
{    
    if(m_chanIdx != chanIdx){
        m_chanIdx = chanIdx;
        Q_EMIT chanIdxChanged();
    }
}

inline int stripPoint(const int y, const int height, const int scale){
    int sc_tp = 0;// temporary set sc_tp = 0
    int pt  = sc_tp + (height-1-y) * scale;
    return pt;
}

bool StripChartItem::transformData2Strip()
{
    if(m_data.empty()) return false;
    int j;
    int cent,x0,x,xmax,xmin;
    int a,b,c;
    short vxavg,vyavg;
    int pix;

    vxavg = vyavg = 0;

    m_points.clear();
    LissDataMap::iterator dataIt = m_data.begin();
    for (; dataIt != m_data.end(); dataIt++) {
        Channel* channel = dataIt.value();
        const int scaleMax = channel->getRawNpt()/height();
        if(m_scale > scaleMax) m_scale = scaleMax;
        int pt0 = m_scale * height() - 1;
        const int FACTOR = 100;
        float theta = M_PI * 0/180.0;
        const int span = 2784;
        a = -(FACTOR * width() * qSin(theta));
        b = FACTOR * width() * qCos(theta);
        c = FACTOR * span;


        //cal xavg point
        int dpt = stripPoint(m_avgPoint, height(), m_scale);
        if(dpt < 0 || dpt >= channel->getData().size()){ //invalid dpt then calculate avg data
            AnserGlobal::calAvgXY(channel, vxavg, vyavg);
        }else{
           const QPoint& data = channel->at(dpt);
           vxavg = static_cast<short>(data.x());
           vyavg = static_cast<short>(data.y());
        }
        ChannelParam& cp = channel->getCp();
        cp.xavg = vxavg;
        cp.yavg = vyavg;
        pix = 0;
        cent = width()/2;
        int npt = channel->getData().count();
        if(pt0 >= 0 && pt0 < npt)
            {
            x0 = cent + (a*(channel->at(pt0).x()-vxavg) + b*(channel->at(pt0).y()-vyavg))/c;
            }
        else
            x0 = cent;
        pt0--;
    /* move to first point */

        QVector<QPointF>& points = m_points[dataIt.key()];
        points.clear();

        points.push_back(QPointF(x0, pix));

        while(pix < height())
            {
    /* find the min and max on this pixel */
            x = xmin = xmax = x0;
            for(j = 1; j < m_scale; ++j)
                {
                if(pt0 >= 0 && pt0 < npt)
                    {
                    x = cent + (a*(channel->at(pt0).x()-vxavg) + b*(channel->at(pt0).y()-vyavg))/c;
                    }
                else
                    x = cent;
                pt0--;
                if(x < xmin)
                    xmin = x;
                else if(x > xmax)
                    xmax = x;
                }

            if(pt0 >= 0 && pt0 < npt)
                {
                x0 = cent + (a*(channel->at(pt0).x()-vxavg) + b*(channel->at(pt0).y()-vyavg))/c;
                }
            else
                x0 = cent;

            pt0--;
            points.push_back(QPointF(xmin, pix));
            points.push_back(QPointF(xmax, pix));
            points.push_back(QPointF(x, pix));
            points.push_back(QPointF(x0, ++pix));

        }

    }
    return true;
}

int StripChartItem::avgPoint() const
{
    return m_avgPoint;
}

void StripChartItem::setAvgPoint(int avgPoint)
{
    if(m_avgPoint != avgPoint){
        m_avgPoint = avgPoint;
        Q_EMIT avgPointChanged();
    }
}

void StripChartItem::pushData(Channel *chan)
{
    if(chan != nullptr){
        if(!m_multiYearMode) m_data.clear();
        LissDataMap::iterator dataIt = m_data.find(chan->getDataSetId());
        if(dataIt == m_data.end()){
            m_data[chan->getDataSetId()] = chan;
        }
        update();
    }
}

int StripChartItem::scale() const
{
    return m_scale;
}

void StripChartItem::setScale(int scale)
{
    m_scale = scale;
}


void StripChartItem::paint(QPainter *painter)
{
    painter->fillRect(0, 0, width(), height(), m_bgrColor);
    painter->setPen(m_borderColor);
    painter->drawRect(0, 0, width(), height());
    if(transformData2Strip() == true){
        for (LissPointMap::iterator it = m_points.begin(); it != m_points.end(); it++) {
            painter->setPen(QColor("white"));
            const QVector<QPointF>& points = it.value();
            for (int i = 0; i < points.count() - 1; ++i) {
                painter->drawLine(points[i], points[i+1]);
            }
        }
    }
}
