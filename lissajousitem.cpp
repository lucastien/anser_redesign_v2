#include "lissajousitem.h"
#include "anserglobal.h"
#include <QPainter>
#include <QtMath>
LissajousItem::LissajousItem(QQuickPaintedItem *parent):
    QQuickPaintedItem (parent),
    m_startPoint(-1),
    m_endPoint(-1),
    m_multiYearMode(false),
    m_bgrColor("black"),
    m_borderColor("#524d4d")
{

}

int LissajousItem::chanIdx() const
{
    return m_chanIdx;
}

void LissajousItem::setChanIdx(int chanIdx)
{
    if(m_chanIdx != chanIdx){
        m_chanIdx = chanIdx;
        Q_EMIT chanIdxChanged();
    }    
}


void LissajousItem::paint(QPainter *painter)
{
    painter->fillRect(0, 0, width(), height(), m_bgrColor);
    painter->setPen(m_borderColor);
    painter->drawRect(0, 0, width(), height());
    if(transformData2Liss() == true){
        for (LissPointMap::iterator it = m_points.begin(); it != m_points.end(); it++) {
            painter->setPen(QColor("white"));
            const QVector<QPointF>& points = it.value();
            for (int i = 0; i < points.count() - 1; ++i) {
                painter->drawLine(points[i], points[i+1]);
            }
        }
    }
}

bool LissajousItem::transformData2Liss()
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

QColor LissajousItem::getBorderColor() const
{
    return m_borderColor;
}

void LissajousItem::setBorderColor(const QColor &borderColor)
{
    if(m_borderColor != borderColor){
        m_borderColor = borderColor;
        Q_EMIT borderColorChanged();
    }

}

QColor LissajousItem::getBgrColor() const
{
    return m_bgrColor;
}

void LissajousItem::setBgrColor(const QColor &bgrColor)
{
    if(m_bgrColor != bgrColor){
        m_bgrColor = bgrColor;
        Q_EMIT bgrColorChanged();
    }

}

bool LissajousItem::multiYearMode() const
{
    return m_multiYearMode;
}

void LissajousItem::setMultiYearMode(bool multiYearMode)
{
    m_multiYearMode = multiYearMode;
}

void LissajousItem::pushData(Channel* channel)
{
    if(channel != nullptr){
        if(!m_multiYearMode) m_data.clear();
        LissDataMap::iterator dataIt = m_data.find(channel->getDataSetId());
        if(dataIt == m_data.end()){
            m_data[channel->getDataSetId()] = channel;
        }
        update();
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
