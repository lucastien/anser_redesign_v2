#ifndef STRIPCHARTITEM_H
#define STRIPCHARTITEM_H

#include <QQuickItem>

class StripChartItem : public QQuickItem
{
    Q_PROPERTY(int chanIndex READ chanIdx WRITE setChanIdx NOTIFY chanIdxChanged)
    Q_OBJECT
public:
    explicit StripChartItem(QQuickItem *parent = nullptr);

    int chanIdx() const;
    void setChanIdx(int chanIdx);

signals:
    void chanIdxChanged();
public slots:

private:
    int m_chanIdx;
};

#endif // STRIPCHARTITEM_H
