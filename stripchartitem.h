#ifndef STRIPCHARTITEM_H
#define STRIPCHARTITEM_H

#include <QQuickPaintedItem>
#include "channel.h"

class StripChartItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int chanIndex READ chanIdx WRITE setChanIdx NOTIFY chanIdxChanged)
    Q_PROPERTY(int scale READ scale WRITE setScale NOTIFY scaleChanged)
    Q_PROPERTY(int avgPoint READ avgPoint WRITE setAvgPoint NOTIFY avgPointChanged)
    typedef QMap<QString, QVector<QPointF>> LissPointMap;
    typedef QMap<QString, Channel*> LissDataMap;

public:
    explicit StripChartItem(QQuickPaintedItem *parent = nullptr);

    int chanIdx() const;
    void setChanIdx(int chanIdx);

    int scale() const;
    void setScale(int scale);

    int avgPoint() const;
    void setAvgPoint(int avgPoint);

    // QQuickPaintedItem interface
    void paint(QPainter *painter) override;
    Q_INVOKABLE void pushData(Channel* chan);
signals:
    void chanIdxChanged();
    void scaleChanged();
    void avgPointChanged();
private:
    bool transformData2Strip();


private:
    int m_chanIdx;
    int m_scale;
    int m_avgPoint;
    bool m_multiYearMode;
    LissDataMap m_data; //support draw multiple data set with key = year
    LissPointMap m_points;
    QColor m_bgrColor;
    QColor m_borderColor;

};

#endif // STRIPCHARTITEM_H
