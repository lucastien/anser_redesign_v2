
#include <QDebug>
#include <QFile>
#include <QDataStream>
#include <QtEndian>
#include <QtMath>
#include <QPointF>
#include <QDateTime>
#include <iostream>
#include <fstream>

#ifdef WIN32
#include "winsock2.h"
#else
#include <arpa/inet.h>
#endif

#include "channel.h"
#include "tubehandler.h"
#include "anserglobal.h"
#include "tubeloader.h"


TubeHandler::TubeHandler(QObject *parent) : QObject(parent),
    m_locateFile(QString()),
    tubeFile(QString(":/data/005021023102.T")),
    m_histTubeFile(QString(":/data/005021023102.T")),
    m_baseTubeFile(QString(":/data/005021023102.T")),
    m_scale(1)
{
}

TubeHandler::~TubeHandler()
{

}

QString TubeHandler::getTubeFile()
{
    return tubeFile;
}

int TubeHandler::getScale() const
{
    return m_scale;
}

void TubeHandler::setScale(const int scale)
{
    if(m_scale != scale){
        m_scale = scale;
        Q_EMIT scaleChanged();
    }
}


QString TubeHandler::getHistTubeFile() const
{
    return m_histTubeFile;
}

void TubeHandler::setHistTubeFile(const QString &histTubeFile)
{
    m_histTubeFile = histTubeFile;
}


int TubeHandler::maxScale(const int height) const
{
    if (m_tube.data()) {
        return m_tube->raw_npt/height;
    }
    return -1;
}


void TubeHandler::setTubeFile(const QString &path)
{
    tubeFile = path;
}

bool TubeHandler::loadTube()
{

    m_tube.reset(new TubeData);
    TubeLoader loader(m_tube.data(), tubeFile);
    if(loader.loadTube()){
        emit tubeLoaded();
        return true;
    }
    return false;

}

bool TubeHandler::loadHistTube()
{
    m_histTube.reset(new TubeData);
    TubeLoader loader(m_histTube.data(), m_histTubeFile);
    if(loader.loadTube("HIS")){
        emit histTubeLoaded();
        return true;
    }
    return false;
}

bool TubeHandler::loadBaseTube()
{
    m_baseTube.reset(new TubeData);
    TubeLoader loader(m_baseTube.data(), m_baseTubeFile);
    if(loader.loadTube("BASE")){
        emit baseTubeLoaded();
        return true;
    }
    return false;
}




void TubeHandler::calAvgData(const Channel& channel, short &vxavg, short &vyavg) const
{
    for (int i = 0; i < m_tube->raw_npt; i++) {
        const QPoint& data = channel.at(i);
        vxavg += data.x();
        vyavg += data.y();
    }
    vxavg = vxavg/m_tube->raw_npt;
    vyavg = vyavg/m_tube->raw_npt;
}

QString TubeHandler::getLocateFile() const
{
    return m_locateFile;
}

void TubeHandler::setLocateFile(const QString &locateFile)
{
    if(m_locateFile != locateFile){
        m_locateFile = locateFile;
        Q_EMIT locateFileChanged();
    }
}


QList<QObject *> TubeHandler::getChannels() const
{
    if(m_tube != nullptr || !m_tube->channels.empty()){
        return QList<QObject*>();
    }
    QList<QObject *> channels;
    QMap<int, ChannelPtr>::iterator it = m_tube->channels.begin();
    for (;it != m_tube->channels.end();++it) {
        Channel *ch = it.value().data();
        channels.push_back(ch);
    }
    return channels;
}

Channel *TubeHandler::getChannel(const int idx) const
{
    if(m_tube == nullptr ||
      m_tube->channels.empty() ||
      idx < 0 ||
      idx >= m_tube->channels.size()){
        return nullptr;
    }
    QMap<int, ChannelPtr>::iterator it = m_tube->channels.begin();
    for (;it != m_tube->channels.end();++it) {
        if(it.key() == idx){
            return it.value().data();
        }
    }
    return nullptr;
}

Channel *TubeHandler::getHistChannel(const int idx) const
{
    if(m_histTube.data() == nullptr ||
      m_histTube->channels.empty() ||
      idx < 0 ||
      idx >= m_histTube->channels.size()){
        return nullptr;
    }
    QMap<int, ChannelPtr>::iterator it = m_histTube->channels.begin();
    for (;it != m_histTube->channels.end();++it) {
        if(it.key() == idx){
            return it.value().data();
        }
    }
    return nullptr;
}

Channel *TubeHandler::getBaseChannel(const int idx) const
{
    if(m_baseTube.data() == nullptr ||
      m_baseTube->channels.empty() ||
      idx < 0 ||
      idx >= m_baseTube->channels.size()){
        return nullptr;
    }
    QMap<int, ChannelPtr>::iterator it = m_baseTube->channels.begin();
    for (;it != m_baseTube->channels.end();++it) {
        if(it.key() == idx){
            return it.value().data();
        }
    }
    return nullptr;
}
