#ifndef CHANNEL_H
#define CHANNEL_H

#include <QObject>
#include <QVector>

class ChannelQMLItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(int xavg READ getXavg)
    Q_PROPERTY(int yavg READ getYavg)
public:
    explicit ChannelQMLItem(QObject *parent = nullptr);
    QString getName() const {return name;}
    void setName(const QString& name_){ name = name_;}
    int getXavg() const {return xavg;}
    int getYavg() const {return yavg;}
    void setXavg(int xavg_){xavg = xavg_;}
    void setYavg(int yavg_){yavg = yavg_;}

signals:
    void dataChanged();
public slots:

private:
    QVector<QPoint> m_rawData;
    QString name;
    int xavg, yavg;
};

#endif // CHANNEL_H
