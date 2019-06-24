#ifndef MOUNTLISTHANDLER_H
#define MOUNTLISTHANDLER_H

#include <QObject>
#include "disktablemodel.h"

class MountListHandler : public QObject
{
    Q_OBJECT
public:
    explicit MountListHandler(QObject *parent = nullptr);
    void setDiskModel(DiskTableModel* model_);

public slots:
    void update(const QString& hostName);
private:
    DiskTableModel *model;
};

#endif // MOUNTLISTHANDLER_H
