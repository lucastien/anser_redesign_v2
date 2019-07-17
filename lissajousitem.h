#ifndef LISSAJOUSITEM_H
#define LISSAJOUSITEM_H

#include "basechartitem.h"

class LissajousItem : public BaseChartItem
{
    Q_OBJECT
    Q_PROPERTY(int startPoint READ startPoint WRITE setStartPoint NOTIFY startPointChanged)
    Q_PROPERTY(int endPoint READ endPoint WRITE setEndPoint NOTIFY endPointChanged)

public:
    explicit LissajousItem(QQuickPaintedItem *parent = nullptr);

    int startPoint() const;
    void setStartPoint(int startPoint);

    int endPoint() const;
    void setEndPoint(int endPoint);

signals:
    void startPointChanged();
    void endPointChanged();

private:
    // BaseChartItem interface
    bool transform() override;


private:
    int m_startPoint;
    int m_endPoint;

};

#endif // LISSAJOUSITEM_H
