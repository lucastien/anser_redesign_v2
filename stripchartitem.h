#ifndef STRIPCHARTITEM_H
#define STRIPCHARTITEM_H

#include "basechartitem.h"

class StripChartItem : public BaseChartItem
{
    Q_OBJECT
    Q_PROPERTY(int scale READ scale WRITE setScale NOTIFY scaleChanged)
    Q_PROPERTY(int avgPoint READ avgPoint WRITE setAvgPoint NOTIFY avgPointChanged)
    Q_PROPERTY(int cursorWidth READ cursorWidth NOTIFY cursorWidthChanged)


public:
    explicit StripChartItem(QQuickPaintedItem *parent = nullptr);

    int scale() const;
    void setScale(int scale);
    int avgPoint() const;
    void setAvgPoint(int avgPoint);
    int cursorWidth() const;
    void setCursorWidth(int cursorWidth);

    Q_INVOKABLE int pixToDpt(const int pix) const;
    Q_INVOKABLE int calCursorWidth(const int currentPix, const int expWidth);

signals:
    void scaleChanged();
    void avgPointChanged();
    void cursorWidthChanged();
private:
    bool transform() override;

private:
    int m_scale;
    int m_avgPoint;
    int m_cursorWidth;
};

#endif // STRIPCHARTITEM_H
