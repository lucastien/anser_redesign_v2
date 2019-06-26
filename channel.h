#ifndef CHANNEL_H
#define CHANNEL_H

#include <QString>
#include <QVector>
#include <QPoint>
#include "channelparam.h"

class Channel{
public:
    explicit Channel(const QString& name_ = QString());
    Channel(const Channel& ch); //copy constructor
    void add(const short x, const short y);
    void clear();
    const QPoint &at(const int i) const;
    ChannelParam &getCp();
    const QVector<QPoint> &getData() const;
private:
    QString m_Name;
    QVector<QPoint> m_Data;
    ChannelParam cp;
};

#endif // CHANNEL_H
