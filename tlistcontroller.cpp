#include "tlistcontroller.h"
#include "global.h"
#include <QDir>
#include <QFileInfoList>
#include <QDebug>

TlistController::TlistController(QObject *parent) :
    QObject(parent),
    model(nullptr),
    reelModel(nullptr)
{

}

void TlistController::setDiskModel(DiskTableModel *model_)
{
    model = model_;
}

void TlistController::setReelModel(ReelInfoModel *model_)
{
    reelModel = model_;
}

void TlistController::updateDiskModel(const QString &hostName)
{
    if(hostName == "localhost"){
#ifdef WIN32
        QDir dir("/raw_disk");
#else
        QString homePath = QDir::homePath();
        QDir dir(homePath+"/raw_disk")
#endif
        QList<DiskItem> items;
        QFileInfoList fileInfoList = dir.entryInfoList(QDir::Dirs | QDir::NoSymLinks | QDir::NoDotAndDotDot);
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
                QFileInfoList reelDirInfoList = subDir.entryInfoList(QDir::Dirs | QDir::NoSymLinks | QDir::NoDotAndDotDot);
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

void TlistController::getReel(const QVariantMap &diskInfoMap)
{
    QString alpha = diskInfoMap["alpha"].toString();
    QString diskId = diskInfoMap["diskId"].toString();
    QString unit;
    unit.sprintf("%02d", diskInfoMap["unit"].toInt());
    QString leg = diskInfoMap["leg"].toString();
    QString sg = diskInfoMap["sg"].toString();
    QString reel;
    reel.sprintf("%03d", diskInfoMap["reel"].toInt());
    QString reelStrFormat = QString("/raw_disk/DISK_%1_%2_%3%4%5/REEL.%6")
                            .arg(alpha).arg(diskId).arg(unit).arg(leg).arg(sg).arg(reel);
    QDir reelDir(reelStrFormat);
    QStringList nameFilter;
    nameFilter << "*.M" << "*.T" << "*.E";
    QFileInfoList fileInfoList = reelDir.entryInfoList(nameFilter, QDir::Files);
    QVector<ReelInfoItem> items;
    foreach(QFileInfo file, fileInfoList){
        qDebug() << file.filePath() << "Size:" << file.size()/1024;
        QByteArray oString = file.fileName().toUtf8();
        const char *pszString = oString.constData();
        char idlab[10],rowlab[10],collab[10], typelab[10];
        int e;
        sscanf(pszString,"%03d%3s%3s%3s.%1s",&e,idlab,rowlab,collab,typelab);
        if(file.completeSuffix() == "M"){
            ReelInfoItem item(false, e+1, QString("***"), QString("MSG"),
                              QString("***"), QString("1612"), file.size()/1024,
                              QString("1/10"), QString("*"), file.filePath());
            items.push_back(item);
       }else if(file.completeSuffix() == "T"){
            QString sgId(idlab);
            if(QString(rowlab) == "999")
                sgId = "CAL";
            ReelInfoItem item(false, e+1, sgId, QString(rowlab),
                              QString(collab), QString("1612"), file.size()/1024,
                              QString("1/1"), QString("*"), file.filePath());
            items.push_back(item);
        }else{
            ReelInfoItem item(false, e+1, QString("***"), QString("END"),
                              QString("***"), QString("1612"), file.size()/1024,
                              QString("1/10"), QString("*"), file.filePath());
            items.push_back(item);
        }
    }


    reelModel->addItems(items);
}
