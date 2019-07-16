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
    Q_PROPERTY(QString tubeFile READ getTubeFile WRITE setTubeFile)
    Q_PROPERTY(QList<QObject*> channels READ getChannels NOTIFY channelsChanged)
    Q_PROPERTY(int scale READ getScale WRITE setScale NOTIFY scaleChanged)
    Q_PROPERTY(int cursorWidth READ getCursorWidth NOTIFY cursorWidthChanged)
    Q_PROPERTY(int expTp READ getExpTp WRITE setExpTp NOTIFY expTpChanged)
    Q_PROPERTY(int expWidth READ getExpWidth WRITE setExpWidth NOTIFY expWidthChanged)
    Q_PROPERTY(int expHeight READ getExpHeight WRITE setExpHeight NOTIFY expHeightChanged)
    Q_PROPERTY(int pt0 READ getPt0 WRITE setPt0 NOTIFY pt0Changed)
    Q_PROPERTY(int npt READ getNpt WRITE setNpt NOTIFY nptChanged)
    Q_OBJECT
public:
    explicit TubeHandler(QObject *parent = nullptr);
    ~TubeHandler();
    void setTubeFile(const QString& path);
    QString getTubeFile();
    int getScale() const;
    void setScale(const int scale);
    int getCursorWidth() const;
    Q_INVOKABLE Channel *getChannel(const int idx) const;
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

    int getPt0() const;
    void setPt0(int Pt0);

    int getNpt() const;
    void setNpt(int Npt);
    QList<QObject *> getChannels() const;
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
    void lissWidthChanged();
    void lissHeightChanged();
    void pt0Changed();
    void nptChanged();
    void channelsChanged();
private:
    int sizeHeader( TubeHeader *hdr, QDataStream& in);
    int initTube(const int npt);
    void calAvgData(const Channel& channel, short& xavg, short& yavg) const;
    int formatBuff(char *buff,int nbyte);
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
    int m_lissWidth, m_lissHeight;
    int m_Pt0, m_Npt;

};

#endif // TUBEHANDLER_H
