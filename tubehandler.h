#ifndef TUBEHANDLER_H
#define TUBEHANDLER_H

#include <QObject>
#include <QDataStream>
#include <QVector>
#include <QPoint>
#include <QMap>

#include "data.h"
#include "channelqmlitem.h"

class TubeHandler : public QObject
{
    Q_PROPERTY(QString tubeFile READ getTubeFile WRITE setTubeFile)

    Q_OBJECT
public:
    explicit TubeHandler(QObject *parent = nullptr);
    ~TubeHandler();
    void setTubeFile(const QString& path);
    QString getTubeFile();
    Q_INVOKABLE int getDrawPointList(const int chan, const int xavg_p, const int width, const int height);
    Q_INVOKABLE QPoint getPoint(const int i);
public slots:
    bool loadTube();

signals:
    void tubeLoaded();
private:
    int sizeHeader( TubeHeader *hdr, QDataStream& in);
    int initTube(const int npt);
private:
    QScopedPointer<TubeData> m_tube;
    QScopedPointer<Channel> m_chan;

    QString tubeFile;
    QVector<QPoint> points;
    QMap<int, int> pointMap;
};

#endif // TUBEHANDLER_H
