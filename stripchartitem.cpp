#include "stripchartitem.h"

StripChartItem::StripChartItem(QQuickItem *parent): QQuickItem (parent)
{

}

int StripChartItem::chanIdx() const
{
    return m_chanIdx;
}

void StripChartItem::setChanIdx(int chanIdx)
{    
    if(m_chanIdx != chanIdx){
        m_chanIdx = chanIdx;
        Q_EMIT chanIdxChanged();
    }
}
