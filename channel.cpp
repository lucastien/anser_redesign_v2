#include <QObject>
#include "channel.h"

Channel::Channel(const QString& name_, QObject *parent):
    QObject (parent),
    m_Name(name_)
{
    memset(&cp, 0, sizeof (ChannelParam));
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

QString Channel::getDataSetId() const
{
    return m_dataSetId;
}

void Channel::setDataSetId(const QString &dataSetId)
{
    m_dataSetId = dataSetId;
}

