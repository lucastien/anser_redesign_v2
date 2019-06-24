#include "mountlisthandler.h"

#include <QDir>
#include <QFileInfoList>
#include <QDebug>

MountListHandler::MountListHandler(QObject *parent) :
    QObject(parent),
    model(nullptr)
{

}

void MountListHandler::setDiskModel(DiskTableModel *model_)
{
    model = model_;
}

void MountListHandler::update(const QString &hostName)
{
    if(hostName == "localhost"){
        QDir dir("/raw_disk");
        QList<DiskItem> items;
        QFileInfoList fileInfoList = dir.entryInfoList(QDir::Dirs|QDir::NoSymLinks | QDir::NoDotAndDotDot);
        foreach (QFileInfo file, fileInfoList) {
            const QString& diskName = file.fileName();
            QRegExp regDisk("DISK_(\\w+)_(\\w+)_(\\d+)([HC])(\\w+)");
            QRegExp regReel("REEL.(\\d+)");
            QString alpha, diskid, leg, sg;
            int unit;
            if (regDisk.indexIn(diskName, 0) != -1) {
                alpha =  regDisk.cap(1);
                diskid =  regDisk.cap(2);
                unit = regDisk.cap(3).toInt();
                leg = regDisk.cap(4);
                sg = regDisk.cap(5);
                QDir subDir(file.filePath());
                QFileInfoList reelDirInfoList = subDir.entryInfoList(QDir::Dirs|QDir::NoSymLinks | QDir::NoDotAndDotDot);
                foreach (QFileInfo reelDir, reelDirInfoList) {
                    if(regReel.indexIn(reelDir.fileName(), 0) != -1){
                        int reelNum = regReel.cap(1).toInt();
                        DiskItem item(reelNum, diskid, sg, leg, unit, alpha);
                        items.push_back(item);
                    }
                }
            }

        }
        if(items.count() > 0 && model){
             model->addItems(items);
        }
    }
}
