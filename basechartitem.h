#ifndef BASECHARTITEM_H
#define BASECHARTITEM_H

#include <QQuickPaintedItem>
#include <QColor>
#include "channel.h"

class BaseChartItem: public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor borderColor READ borderColor WRITE setBorderColor NOTIFY borderColorChanged)
    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor NOTIFY penColorChanged)

public:
    explicit BaseChartItem(QQuickPaintedItem *parent = nullptr);
    virtual ~BaseChartItem();
    QColor borderColor() const;
    void setBorderColor(const QColor &borderColor);
    // QQuickPaintedItem interface
    virtual void paint(QPainter *painter);
    Q_INVOKABLE virtual void pushData(Channel* channel);
    bool multiYearMode() const;
    void setMultiYearMode(bool multiYearMode);
    virtual bool transform() = 0;
    QColor penColor() const;
    void setPenColor(const QColor &penColor);

signals:
    void borderColorChanged();
    void penColorChanged();
protected:
    typedef QMap<QString, QVector<QPointF>> LissPointMap;
    typedef QMap<QString, Channel*> LissDataMap;

    bool m_multiYearMode;
    LissDataMap m_data; //support draw multiple data set with key = year
    LissPointMap m_points;
    QColor m_borderColor;
    QColor m_penColor;
};

#endif // BASECHARTITEM_H
