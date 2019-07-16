#include <QtMath>
#include <QPainter>

#include "expstripchartitem.h"
#include "anserglobal.h"

ExpStripChartItem::ExpStripChartItem(QQuickPaintedItem *parent):
    QQuickPaintedItem (parent),
    m_expTp(0),
    m_xComponent(false),
    m_multiYearMode(false),
    m_bgrColor("black"),
    m_borderColor("#524d4d")
{

}


void ExpStripChartItem::paint(QPainter *painter)
{
    painter->fillRect(0, 0, width(), height(), m_bgrColor);
    painter->setPen(m_borderColor);
    painter->drawRect(0, 0, width(), height());
    if(transform() == true){
        for (LissPointMap::iterator it = m_points.begin(); it != m_points.end(); it++) {
            painter->setPen(QColor("white"));
            const QVector<QPointF>& points = it.value();
            for (int i = 0; i < points.count() - 1; ++i) {
                painter->drawLine(points[i], points[i+1]);
            }
        }
    }
}

QColor ExpStripChartItem::bgrColor() const
{
    return m_bgrColor;
}

void ExpStripChartItem::setBgrColor(const QColor &bgrColor)
{
    m_bgrColor = bgrColor;
}

QColor ExpStripChartItem::borderColor() const
{
    return m_borderColor;
}

void ExpStripChartItem::setBorderColor(const QColor &borderColor)
{
    m_borderColor = borderColor;
}

bool ExpStripChartItem::transform()
{

    if(m_data.empty() || m_expTp < 0) return false;

    int k;
    short base;
    int a,b,c,vxavg,vyavg,cent;
    int vx,vy,pnt;
    int x1, y1;

    if(height() < 2)
        return false;

    m_points.clear();
    LissDataMap::iterator dataIt = m_data.begin();
    for (; dataIt != m_data.end(); dataIt++) {
        Channel* channel = dataIt.value();
        if(m_expTp > channel->getData().count()) return false;
        ChannelParam& cp = channel->getCp();
        if(cp.xavg == 0){
            AnserGlobal::calAvgXY(channel, cp.xavg, cp.yavg);
        }
        vxavg = cp.xavg;
        vyavg = cp.yavg;


        /* get transformation coefficients */
        const int FACTOR = 100;
        float theta = M_PI * cp.rot/180.0;
        const int span = 2784;
        a = FACTOR * width() * qCos(theta);
        b = FACTOR * width() * qSin(theta);
        c = FACTOR * span;

        cent = width()/2;
        if (c==0) c=1;

        /* setup y coordinates */
        base = (height()-1);
        pnt = m_expTp;

        QVector<QPointF>& points = m_points[dataIt.key()];
        points.clear();

        for(k = 0; k < height(); ++k){
            y1 = base--;
            vx = channel->at(pnt).x() - vxavg;
            vy = channel->at(pnt).y() - vyavg;
            if(m_xComponent){
                x1 = cent + (-b*vx + a*vy)/c;
            }else {
                x1 = cent + (a*vx + b*vy)/c;
            }
            points.push_back(QPoint(x1, y1));
            if(++pnt >= channel->getRawNpt()) pnt = 0;
        }
    }
    return true;
}

bool ExpStripChartItem::xComponent() const
{
    return m_xComponent;
}

void ExpStripChartItem::setXComponent(bool xComponent)
{
    m_xComponent = xComponent;
}

void ExpStripChartItem::pushData(Channel *chan)
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

int ExpStripChartItem::expTp() const
{
    return m_expTp;
}

void ExpStripChartItem::setExpTp(int expTp)
{
    if(m_expTp != expTp){
        m_expTp = expTp;
        Q_EMIT expTpChanged();
    }
}
