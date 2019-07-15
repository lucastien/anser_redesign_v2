#ifndef ANSERGLOBAL_H
#define ANSERGLOBAL_H

class Channel;

class AnserGlobal
{
public:
    AnserGlobal();
    static void calAvgXY(const Channel* channel, short &vxavg, short &vyavg);
};

#endif // ANSERGLOBAL_H
