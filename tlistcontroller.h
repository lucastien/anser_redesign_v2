#ifndef MOUNTLISTHANDLER_H
#define MOUNTLISTHANDLER_H

#include <QObject>
#include "disktablemodel.h"
#include "reelinfomodel.h"

class TlistController : public QObject
{
    Q_OBJECT
public:
    explicit TlistController(QObject *parent = nullptr);
    void setDiskModel(DiskTableModel* model_);
    void setReelModel(ReelInfoModel* model_);
public slots:
    void updateDiskModel(const QString& hostName);
    void getReel(const QVariantMap& diskInfoMap);
private:
    DiskTableModel *model;
    ReelInfoModel *reelModel;
};

#endif // MOUNTLISTHANDLER_H
