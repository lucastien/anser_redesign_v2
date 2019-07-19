#include "basechartitem.h"
#include <QPainter>

BaseChartItem::BaseChartItem(QQuickPaintedItem *parent):
    QQuickPaintedItem (parent),
    m_multiYearMode(false),
    m_borderColor("#524d4d"),
    m_penColor("white")
{

}

BaseChartItem::~BaseChartItem()
{

}

QColor BaseChartItem::borderColor() const
{
    return m_borderColor;
}

void BaseChartItem::setBorderColor(const QColor &borderColor)
{
    if(m_borderColor != borderColor){
        m_borderColor = borderColor;
        Q_EMIT borderColorChanged();
    }
}

void BaseChartItem::paint(QPainter *painter)
{
    //painter->fillRect(0, 0, width(), height(), m_bgrColor);
    painter->setPen(m_borderColor);
    int w = static_cast<int>(width());
    int h = static_cast<int>(height());
    painter->drawRect(0, 0, w, h);
    if(transform() == true){
        for (LissPointMap::iterator it = m_points.begin(); it != m_points.end(); it++) {
            painter->setPen(m_penColor);
            const QVector<QPointF>& points = it.value();
            for (int i = 0; i < points.count() - 1; ++i) {
                painter->drawLine(points[i], points[i+1]);
            }
        }
    }
}

void BaseChartItem::pushData(Channel *channel)
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

bool BaseChartItem::multiYearMode() const
{
    return m_multiYearMode;
}

void BaseChartItem::setMultiYearMode(bool multiYearMode)
{
    m_multiYearMode = multiYearMode;
}

QColor BaseChartItem::penColor() const
{
    return m_penColor;
}

void BaseChartItem::setPenColor(const QColor &penColor)
{
    if(m_penColor != penColor){
        m_penColor = penColor;
        Q_EMIT penColorChanged();
    }
}
