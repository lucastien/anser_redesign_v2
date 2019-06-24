#ifndef DISKITEM_H
#define DISKITEM_H
#include <QString>

struct DiskItem{
    explicit DiskItem(int reel_ = -1,
            const QString& diskId_ = QString(),
            const QString& sg_ = QString(),
            const QString& leg_ = QString(),
            int unit_ = -1,
            const QString& alpha_ = QString())
        : reel(reel_), diskId(diskId_), sg(sg_), leg(leg_), unit(unit_), alpha(alpha_){}
    int reel;
    QString diskId;
    QString sg;
    QString leg;
    int unit;
    QString alpha;
};

#endif // DISKITEM_H
