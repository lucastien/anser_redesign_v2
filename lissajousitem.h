#ifndef LISSAJOUSITEM_H
#define LISSAJOUSITEM_H

#include "basechartitem.h"
class Channel;
class LissajousItem : public BaseChartItem
{
    Q_OBJECT
    Q_PROPERTY(int startPoint READ startPoint WRITE setStartPoint NOTIFY startPointChanged)
    Q_PROPERTY(int endPoint READ endPoint WRITE setEndPoint NOTIFY endPointChanged)
    Q_PROPERTY(Channel* priChan READ priChan WRITE setPriChan NOTIFY priChanChanged)
public:
    explicit LissajousItem(QQuickPaintedItem *parent = nullptr);

    int startPoint() const;
    void setStartPoint(int startPoint);

    int endPoint() const;
    void setEndPoint(int endPoint);

    Channel *priChan() const;
    void setPriChan(Channel *priChan);
    Q_INVOKABLE int boundSpan(int span);

signals:
    void startPointChanged();
    void endPointChanged();
    void priChanChanged();

private:
    // BaseChartItem interface
    bool transform() override;


private:
    int m_startPoint;
    int m_endPoint;
    Channel* m_priChan;
};

#endif // LISSAJOUSITEM_H
