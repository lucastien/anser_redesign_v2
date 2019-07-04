#include "channelhandler.h"

ChannelHandler::ChannelHandler(QObject *parent) : QObject(parent)
{

}

int ChannelHandler::getSpan() const
{
    return m_span;
}

void ChannelHandler::setSpan(int span)
{
    if(m_span != span){
        m_span = span;
        Q_EMIT spanChanged();
    }
}

int ChannelHandler::getRot() const
{
    return m_rot;
}

void ChannelHandler::setRot(int rot)
{
    if(m_rot != rot){
        m_rot = rot;
        Q_EMIT rotChanged();
    }
}
