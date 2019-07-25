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
    Q_PROPERTY(QString locateFile READ getLocateFile WRITE setLocateFile NOTIFY locateFileChanged)
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
    Q_INVOKABLE Channel *getHistChannel(const int idx) const;
    Q_INVOKABLE Channel *getBaseChannel(const int idx) const;
    Q_INVOKABLE int maxScale(const int height) const;
    QList<QObject *> getChannels() const;
    QString getHistTubeFile() const;
    void setHistTubeFile(const QString &histTubeFile);

    QString getLocateFile() const;
    void setLocateFile(const QString &locateFile);

public slots:
    bool loadTube();
    //This function is only for multiple year demo purpose
    bool loadHistTube();
    bool loadBaseTube();
signals:
    void tubeLoaded();
    void histTubeLoaded();
    void baseTubeLoaded();
    void scaleChanged();
    void channelsChanged();
    void locateFileChanged();
private:
    void calAvgData(const Channel& channel, short& xavg, short& yavg) const;
private:
    QScopedPointer<TubeData> m_tube;
    QScopedPointer<TubeData> m_histTube;
    QScopedPointer<TubeData> m_baseTube;
    QString m_locateFile;
    QString tubeFile;    
    QString m_histTubeFile, m_baseTubeFile;
    QVector<QPoint> points;
    QVector<QPoint> ePoints;
    int m_scale;

};

#endif // TUBEHANDLER_H
