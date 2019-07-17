#include "lissajousitem.h"
#include "anserglobal.h"
#include <QPainter>
#include <QtMath>
LissajousItem::LissajousItem(QQuickPaintedItem *parent):
    BaseChartItem (parent),
    m_startPoint(-1),
    m_endPoint(-1)
{

}

bool LissajousItem::transform()
{
    if(m_data.empty()) return false;
    if(m_startPoint == -1 || m_endPoint == -1) return false;
    int a,b,c,xcent,ycent;
    int vx,vy,vxavg,vyavg;
    int x1, y1;
    m_points.clear();
    LissDataMap::iterator dataIt = m_data.begin();
    for (; dataIt != m_data.end(); dataIt++) {
        Channel* channel = dataIt.value();
        ChannelParam& cp = channel->getCp();
        if(cp.xavg == 0){
            AnserGlobal::calAvgXY(channel, cp.xavg, cp.yavg);
        }
        vxavg = cp.xavg;
        vyavg = cp.yavg;
        /* get transformation coefficients */
        const int FACTOR = 100;
        float theta = M_PI * 0/180.0;
        const int span = 2784; //temporarily hard code
        double lissW = width();
        double lissH = height();
        a = static_cast<int>(FACTOR * lissW * qCos(theta));
        b = static_cast<int>(FACTOR * lissH * qSin(theta));
        c = FACTOR * span;

        if( c==0) c=1;
        xcent = static_cast<int>(lissW/2);
        ycent = static_cast<int>(lissH/2);

        /* find points (NOTE: positive y axis points downward) */
        int pt0 = m_startPoint;

        QVector<QPointF>& points = m_points[dataIt.key()];
        points.clear();
        int npt = channel->getData().size();
        for(int k = m_startPoint; k <= m_endPoint; ++k)
        {
            if(++pt0 >= npt) pt0=0;

            vx = channel->at(pt0).x() - vxavg;
            vy = channel->at(pt0).y() - vyavg;
            x1 = xcent + (a*vx + b*vy)/c;
            y1 = ycent + (b*vx - a*vy)/c;
            points.push_back(QPointF(x1, y1));
        }
    }
    return true;
}

int LissajousItem::startPoint() const
{
    return m_startPoint;
}

void LissajousItem::setStartPoint(int startPoint)
{
    if(m_startPoint != startPoint){
        m_startPoint = startPoint;
        update();
        Q_EMIT startPointChanged();
    }
}


int LissajousItem::endPoint() const
{
    return m_endPoint;
}

void LissajousItem::setEndPoint(int endPoint)
{
    if(m_endPoint != endPoint){
        m_endPoint = endPoint;
        update();
        Q_EMIT endPointChanged();
    }

}
