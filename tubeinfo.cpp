#include "tubeinfo.h"
#include <QString>
TubeInfo::TubeInfo(QObject *parent):
    QObject (parent),
    m_row(0), m_col(0), m_reel(0), m_unit(0),
    m_sg(QString("")),
    m_leg(QString("")), m_alpha(QString("")), m_diskId(QString(""))

{

}

int TubeInfo::row() const
{
    return m_row;
}

void TubeInfo::setRow(int row)
{
    if(m_row != row){
        m_row = row;
        Q_EMIT rowChanged();
    }
}

int TubeInfo::col() const
{
    return m_col;
}

void TubeInfo::setCol(int col)
{
    if(m_col != col){
        m_col = col;
        Q_EMIT colChanged();
    }

}

int TubeInfo::reel() const
{
    return m_reel;
}

void TubeInfo::setReel(int reel)
{
    if(m_reel != reel){
        m_reel = reel;
        Q_EMIT reelChanged();
    }
}

int TubeInfo::unit() const
{
    return m_unit;
}

void TubeInfo::setUnit(int unit)
{
    if(m_unit != unit){
        m_unit = unit;
        Q_EMIT unitChanged();
    }
}

QString TubeInfo::sg() const
{
    return m_sg;
}

void TubeInfo::setSg(const QString &sg)
{
    if(m_sg != sg){
        m_sg = sg;
        Q_EMIT sgChanged();
    }

}

QString TubeInfo::leg() const
{
    return m_leg;
}

void TubeInfo::setLeg(const QString &leg)
{
    if(m_leg != leg){
        m_leg = leg;
        Q_EMIT legChanged();
    }
}

QString TubeInfo::alpha() const
{
    return m_alpha;
}

void TubeInfo::setAlpha(const QString &alpha)
{
    if(m_alpha != alpha){
        m_alpha = alpha;
        Q_EMIT alphaChanged();
    }
}

QString TubeInfo::diskId() const
{
    return m_diskId;
}

void TubeInfo::setDiskId(const QString &diskId)
{
    if(m_diskId != diskId){
        m_diskId = diskId;
        Q_EMIT diskIdChanged();
    }
}
