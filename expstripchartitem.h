#ifndef EXPSTRIPCHARTITEM_H
#define EXPSTRIPCHARTITEM_H

#include <QQuickPaintedItem>
#include "channel.h"

class ExpStripChartItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int expTp READ expTp WRITE setExpTp NOTIFY expTpChanged)
    Q_PROPERTY(bool xComponent READ xComponent WRITE setXComponent)
    typedef QMap<QString, QVector<QPointF>> LissPointMap;
    typedef QMap<QString, Channel*> LissDataMap;

public:
    explicit ExpStripChartItem(QQuickPaintedItem *parent = nullptr);

signals:
    void expTpChanged();
public slots:

    // QQuickPaintedItem interface
public:
    void paint(QPainter *painter) override;

    QColor bgrColor() const;
    void setBgrColor(const QColor &bgrColor);

    QColor borderColor() const;
    void setBorderColor(const QColor &borderColor);
    int expTp() const;
    void setExpTp(int expTp);

    bool xComponent() const;
    void setXComponent(bool xComponent);
    Q_INVOKABLE void pushData(Channel* chan);
private:
    bool transform();
private:
    int m_expTp;
    bool m_xComponent;
    bool m_multiYearMode;
    LissDataMap m_data; //support draw multiple data set with key = year
    LissPointMap m_points;
    QColor m_bgrColor;
    QColor m_borderColor;
};

#endif // EXPSTRIPCHARTITEM_H
