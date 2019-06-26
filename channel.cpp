#include <QObject>
#include "channel.h"

Channel::Channel(const QString& name_): m_Name(name_)
{
    memset(&cp, 0, sizeof (ChannelParam));
}

Channel::Channel(const Channel& ch)
{
    m_Data = ch.m_Data;
    m_Name = ch.m_Name;
    cp = ch.cp;
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
