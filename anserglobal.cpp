#include "anserglobal.h"
#include "channel.h"

AnserGlobal::AnserGlobal()
{

}

void AnserGlobal::calAvgXY(const Channel *channel, short &vxavg, short &vyavg)
{
    int rawNpt = channel->getRawNpt();
    for (int i = 0; i < rawNpt; i++) {
        const QPoint& data = channel->at(i);
        vxavg += data.x();
        vyavg += data.y();
    }
    vxavg = vxavg/rawNpt;
    vyavg = vyavg/rawNpt;
}

int AnserGlobal::boundSpan(const int span)
{
    int tmpSpan = span;
    int min_span = 100;
    if(tmpSpan < min_span)
        tmpSpan  = min_span;
    else if(tmpSpan > USHRT_MAX)
        tmpSpan = USHRT_MAX;
    return(tmpSpan);

}
