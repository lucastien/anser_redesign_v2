#ifndef LISSAJOUSITEM_H
#define LISSAJOUSITEM_H

#include <QQuickPaintedItem>
#include <QColor>
#include "channel.h"

class LissajousItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int chanIndex READ chanIdx WRITE setChanIdx NOTIFY chanIdxChanged)
    Q_PROPERTY(int startPoint READ startPoint WRITE setStartPoint NOTIFY startPointChanged)
    Q_PROPERTY(int endPoint READ endPoint WRITE setEndPoint NOTIFY endPointChanged)
    Q_PROPERTY(QColor bgrColor READ getBgrColor WRITE setBgrColor NOTIFY bgrColorChanged)
    Q_PROPERTY(QColor borderColor READ getBorderColor WRITE setBorderColor NOTIFY borderColorChanged)

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

    QColor getBgrColor() const;
    void setBgrColor(const QColor &getBgrColor);

    QColor getBorderColor() const;
    void setBorderColor(const QColor &borderColor);

signals:
    void chanIdxChanged();
    void startPointChanged();
    void endPointChanged();
    void bgrColorChanged();
    void borderColorChanged();
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
    QColor m_bgrColor;
    QColor m_borderColor;

};

#endif // LISSAJOUSITEM_H
