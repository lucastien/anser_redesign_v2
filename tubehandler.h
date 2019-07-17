#ifndef TUBEHANDLER_H
#define TUBEHANDLER_H

#include <QObject>
#include <QDataStream>
#include <QVector>
#include <QPoint>
#include <QMap>

#include "data.h"

class TubeHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString tubeFile READ getTubeFile WRITE setTubeFile)
    Q_PROPERTY(QList<QObject*> channels READ getChannels NOTIFY channelsChanged)
    Q_PROPERTY(int scale READ getScale WRITE setScale NOTIFY scaleChanged)
public:
    explicit TubeHandler(QObject *parent = nullptr);
    ~TubeHandler();
    void setTubeFile(const QString& path);
    QString getTubeFile();
    int getScale() const;
    void setScale(const int scale);
    Q_INVOKABLE Channel *getChannel(const int idx) const;
    Q_INVOKABLE int maxScale(const int height) const;
    QList<QObject *> getChannels() const;
public slots:
    bool loadTube();

signals:
    void tubeLoaded();
    void scaleChanged();
    void channelsChanged();
private:
    int sizeHeader( TubeHeader *hdr, QDataStream& in);
    int initTube(const int npt);
    void calAvgData(const Channel& channel, short& xavg, short& yavg) const;
    int formatBuff(char *buff,int nbyte);
private:
    QScopedPointer<TubeData> m_tube;

    QString tubeFile;
    QVector<QPoint> points;
    QVector<QPoint> ePoints;
    int m_scale;

};

#endif // TUBEHANDLER_H
