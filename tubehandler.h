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
    Q_PROPERTY(int stripWidth READ getStripWidth WRITE setStripWidth NOTIFY stripWidthChanged)
    Q_PROPERTY(int stripHeight READ getStripHeight WRITE setStripHeight NOTIFY stripHeightChanged)
    Q_PROPERTY(int scale READ getScale WRITE setScale NOTIFY scaleChanged)
    Q_PROPERTY(int cursorWidth READ getCursorWidth NOTIFY cursorWidthChanged)
    Q_PROPERTY(int expTp READ getExpTp WRITE setExpTp NOTIFY expTpChanged)
    Q_PROPERTY(int expWidth READ getExpWidth WRITE setExpWidth NOTIFY expWidthChanged)
    Q_PROPERTY(int expHeight READ getExpHeight WRITE setExpHeight NOTIFY expHeightChanged)
    Q_OBJECT
public:
    explicit TubeHandler(QObject *parent = nullptr);
    ~TubeHandler();
    void setTubeFile(const QString& path);
    QString getTubeFile();
    int getScale() const;
    void setScale(const int scale);
    int getStripWidth() const;
    void setStripWidth(const int width);
    int getStripHeight() const;
    void setStripHeight(const int height);
    int getCursorWidth() const;
    Q_INVOKABLE int getDrawPointList(const int chan, const int xavg_p);
    Q_INVOKABLE QPoint getPoint(const int i);
    Q_INVOKABLE QPoint getExpPoint(const int i);
    Q_INVOKABLE int maxScale(const int height) const;
    Q_INVOKABLE int getCursorWidth(const int currentPix, const int expWidth);
    Q_INVOKABLE int pixToDpt(const int pix);
    Q_INVOKABLE int calExpPoints(const int chan, bool leftside);

    int getExpTp() const;
    void setExpTp(int expTp);

    int getExpWidth() const;
    void setExpWidth(int expWidth);

    int getExpHeight() const;
    void setExpHeight(int expHeight);

public slots:
    bool loadTube();

signals:
    void tubeLoaded();
    void scaleChanged();
    void stripWidthChanged();
    void stripHeightChanged();
    void cursorWidthChanged();
    void expTpChanged();
    void expWidthChanged();
    void expHeightChanged();
private:
    int sizeHeader( TubeHeader *hdr, QDataStream& in);
    int initTube(const int npt);
    void calAvgData(const Channel& channel, short& xavg, short& yavg) const;
private:
    QScopedPointer<TubeData> m_tube;
    QScopedPointer<Channel> m_chan;

    QString tubeFile;
    QVector<QPoint> points;
    QVector<QPoint> ePoints;
    QMap<int, int> m_point2PixMap;
    int m_scale, m_stripWidth, m_stripHeight;
    int m_cursorWidth;
    int m_expTp, m_expHeight, m_expWidth;

};

#endif // TUBEHANDLER_H
