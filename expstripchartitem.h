#ifndef EXPSTRIPCHARTITEM_H
#define EXPSTRIPCHARTITEM_H

#include "basechartitem.h"

class ExpStripChartItem : public BaseChartItem
{
    Q_OBJECT
    Q_PROPERTY(int expTp READ expTp WRITE setExpTp NOTIFY expTpChanged)
    Q_PROPERTY(bool xComponent READ xComponent WRITE setXComponent)

public:
    explicit ExpStripChartItem(QQuickPaintedItem *parent = nullptr);

signals:
    void expTpChanged();


    // QQuickPaintedItem interface
public:
    int expTp() const;
    void setExpTp(int expTp);

    bool xComponent() const;
    void setXComponent(bool xComponent);
private:
    bool transform() override;
private:
    int m_expTp;
    bool m_xComponent;    
};

#endif // EXPSTRIPCHARTITEM_H
