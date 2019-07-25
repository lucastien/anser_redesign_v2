#include "stripchartitem.h"
#include "anserglobal.h"
#include <QtMath>
#include <QPainter>

StripChartItem::StripChartItem(QQuickPaintedItem *parent):
    BaseChartItem (parent),
    m_scale(1),
    m_avgPoint(0)
{

}

inline int stripPoint(const int y, const int height, const int scale){
    int sc_tp = 0;// temporary set sc_tp = 0
    int pt  = sc_tp + (height-1-y) * scale;
    return pt;
}

int StripChartItem::cursorWidth() const
{
    return m_cursorWidth;
}

void StripChartItem::setCursorWidth(int cursorWidth)
{
    if(m_cursorWidth != cursorWidth){
        m_cursorWidth = cursorWidth;
        Q_EMIT cursorWidthChanged();
    }
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



int StripChartItem::pixToDpt(const int pix) const
{
    return stripPoint(pix, height(), m_scale);
}

inline int stripY(const int hs, const int tp, const int pt, const int scale)
{
    int y = (hs - 1) - (pt - tp)/scale;
    return y;
}

int StripChartItem::calCursorWidth(const int currentPix, const int expWidth)
{

    int center = stripPoint(currentPix, height(), m_scale);

    int expTp = center - expWidth/2;

    int cymin = stripY(height(), 0, expTp+expWidth-1, m_scale);
    int cymax = stripY(height(), 0, expTp, m_scale);
    setCursorWidth(abs(cymax - cymin));
    return m_cursorWidth;
}

bool StripChartItem::transform()
{
    if(m_data.empty()) return false;
    int j;
    int cent,x0,x,xmax,xmin;
    int a,b,c;
    short vxavg,vyavg;
    int pix;

    vxavg = vyavg = 0;

    m_points.clear();
    const int spacing = 20;
    LissDataMap::iterator dataIt = m_data.begin();
    int dataIdx = 0;
    for (; dataIt != m_data.end(); dataIt++) {
        Channel* channel = dataIt.value();
        ChannelParam& cp = channel->getCp();
        const int scaleMax = channel->getRawNpt()/height();
        if(m_scale > scaleMax) m_scale = scaleMax;
        int pt0 = m_scale * height() - 1;
        const int FACTOR = 100;
        float theta = M_PI * cp.rot/180.0;
        a = -(FACTOR * width() * qSin(theta));
        b = FACTOR * width() * qCos(theta);
        c = FACTOR * cp.span;


        //cal xavg point
        int dpt = stripPoint(m_avgPoint, height(), m_scale);
        if(dpt < 0 || dpt >= channel->getData().size()){ //invalid dpt then calculate avg data
            AnserGlobal::calAvgXY(channel, vxavg, vyavg);
        }else{
           const QPoint& data = channel->at(dpt);
           vxavg = static_cast<short>(data.x());
           vyavg = static_cast<short>(data.y());
        }

        cp.xavg = vxavg;
        cp.yavg = vyavg;
        pix = 0;
        cent = width()/2 + dataIdx*spacing;
        dataIdx++;
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

int StripChartItem::scale() const
{
    return m_scale;
}

void StripChartItem::setScale(int scale)
{
    m_scale = scale;
}

