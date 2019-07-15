#ifndef LISSAJOUSITEM_H
#define LISSAJOUSITEM_H

#include <QQuickPaintedItem>
#include "channel.h"

class LissajousItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int chanIndex READ chanIdx WRITE setChanIdx NOTIFY chanIdxChanged)
    Q_PROPERTY(int startPoint READ startPoint WRITE setStartPoint NOTIFY startPointChanged)
    Q_PROPERTY(int endPoint READ endPoint WRITE setEndPoint NOTIFY endPointChanged)

    typedef QMap<QString, QVector<QPointF>> LissPointMap;
    typedef QMap<QString, Channel*> LissDataMap;
public:
    explicit LissajousItem(QQuickPaintedItem *parent = nullptr);

    int chanIdx() const;
    void setChanIdx(int chanIdx);
    // QQuickPaintedItem interface
    void paint(QPainter *painter) override;
    int startPoint() const;
    void setStartPoint(int startPoint);

    int endPoint() const;
    void setEndPoint(int endPoint);

    bool multiYearMode() const;
    void setMultiYearMode(bool multiYearMode);

signals:
    void chanIdxChanged();
    void startPointChanged();
    void endPointChanged();
public slots:
    void pushData(Channel* channel);
private:
    bool transformData2Liss();

private:
    int m_chanIdx;
    int m_startPoint;
    int m_endPoint;
    bool m_multiYearMode;
    LissDataMap m_data; //support draw multiple data set with key = year
    LissPointMap m_points;

};

#endif // LISSAJOUSITEM_H
