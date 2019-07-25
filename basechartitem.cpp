#include "basechartitem.h"
#include <QPainter>

BaseChartItem::BaseChartItem(QQuickPaintedItem *parent):
    QQuickPaintedItem (parent),
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
        int i = 0;
        for (LissPointMap::iterator it = m_points.begin(); it != m_points.end(); it++) {
            painter->setPen(m_colors[it.key()]);
            const QVector<QPointF>& points = it.value();
            for (int i = 0; i < points.count() - 1; ++i) {
                painter->drawLine(points[i], points[i+1]);
            }
        }
    }
}

void BaseChartItem::pushData(Channel *channel, const QColor& color)
{
    if(channel != nullptr){
        LissDataMap::iterator dataIt = m_data.find(channel->getDataSetId());
        if(dataIt == m_data.end()){
            m_data[channel->getDataSetId()] = channel;
            m_colors[channel->getDataSetId()] = color;
        }
        update();
    }
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

Channel *BaseChartItem::at(const int idx)
{
    if(idx < 0 || idx >= m_data.count()) return nullptr;
    return (m_data.begin() + idx).value();
}

void BaseChartItem::clear()
{
    m_data.clear();
    m_colors.clear();
    m_points.clear();
}

