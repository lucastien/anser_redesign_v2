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
    Q_PROPERTY(int cursorWidth READ cursorWidth NOTIFY cursorWidthChanged)

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
    Q_INVOKABLE int pixToDpt(const int pix) const;
    Q_INVOKABLE int calCursorWidth(const int currentPix, const int expWidth);
    int cursorWidth() const;
    void setCursorWidth(int cursorWidth);

signals:
    void chanIdxChanged();
    void scaleChanged();
    void avgPointChanged();
    void cursorWidthChanged();
private:
    bool transformData2Strip();


private:
    int m_chanIdx;
    int m_scale;
    int m_avgPoint;
    bool m_multiYearMode;
    int m_cursorWidth;
    LissDataMap m_data; //support draw multiple data set with key = year
    LissPointMap m_points;
    QColor m_bgrColor;
    QColor m_borderColor;

};

#endif // STRIPCHARTITEM_H
