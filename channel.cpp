#include <QObject>
#include <QDebug>
#include <QQmlEngine>
#include "channel.h"

Channel::Channel(const QString& name_):
    //QObject (parent),
    m_Name(name_),
    m_freq(0)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    memset(&cp, 0, sizeof (ChannelParam));
    cp.span = 2784; //temporarily hard code since setup module is not implemented yet
    cp.vcon = 0.001; //temporarily hard code since setup module is not implemented yet
}

Channel::~Channel()
{
    qDebug() << "Channel " << m_Name << " is being destructed";
}


void Channel::add(const short x, const short y)
{
    m_Data.push_back(QPoint(x, y));
}

void Channel::clear()
{
    m_Data.clear();
}

const QPoint &Channel::at(const int i) const
{
    if(m_Data.isEmpty() || i < 0 || i >= m_Data.size())
        throw QObject::tr("Index out of points array");

    return m_Data[i];
}

ChannelParam &Channel::getCp()
{
    return cp;
}

const QVector<QPoint> &Channel::getData() const
{
    return m_Data;
}

QString Channel::getName() const
{
    return m_Name;
}

void Channel::setName(const QString &Name)
{
    m_Name = Name;
}

int Channel::getRot() const
{
    return cp.rot;
}

void Channel::setRot(int rot_)
{
    if(rot_ != cp.rot){
        cp.rot = rot_;
        Q_EMIT rotChanged();
    }
}

int Channel::getSpan() const
{
    return cp.span;
}

void Channel::setSpan(int span)
{
    if(span != cp.span){
        cp.span = span;
        Q_EMIT spanChanged();
    }
}

int Channel::getRawNpt() const
{
    return m_rawNpt;
}

void Channel::setRawNpt(int rawNpt)
{
    m_rawNpt = rawNpt;
}

float Channel::getVcon() const
{
    return cp.vcon;
}

void Channel::setVcon(float vcon)
{
    cp.vcon = vcon;
    Q_EMIT vconChanged();
}

QString Channel::getDataSetId() const
{
    return m_dataSetId;
}

void Channel::setDataSetId(const QString &dataSetId)
{
    m_dataSetId = dataSetId;
}

QString Channel::getFullName() const
{
    return m_fullName;
}

void Channel::setFullName(const QString &fullName)
{
    m_fullName = fullName;
}

int Channel::getFreq() const
{
    return m_freq;
}

void Channel::setFreq(int freq)
{
    if(m_freq != freq){
        m_freq = freq;
        Q_EMIT freqChanged();
    }

}

