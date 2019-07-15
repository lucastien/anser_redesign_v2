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
