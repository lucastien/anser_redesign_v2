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
    Q_PROPERTY(int stripWidth READ getStripWidth WRITE setStripWidth NOTIFY stripWidthChanged)
    Q_PROPERTY(int stripHeight READ getStripHeight WRITE setStripHeight NOTIFY stripHeightChanged)
    Q_PROPERTY(int scale READ getScale WRITE setScale NOTIFY scaleChanged)
    Q_PROPERTY(int cursorWidth READ getCursorWidth NOTIFY cursorWidthChanged)
    Q_PROPERTY(int expTp READ getExpTp WRITE setExpTp NOTIFY expTpChanged)
    Q_PROPERTY(int expWidth READ getExpWidth WRITE setExpWidth NOTIFY expWidthChanged)
    Q_PROPERTY(int expHeight READ getExpHeight WRITE setExpHeight NOTIFY expHeightChanged)
    Q_PROPERTY(int lissWidth READ getLissWidth WRITE setLissWidth NOTIFY lissWidthChanged)
    Q_PROPERTY(int lissHeight READ getLissHeight WRITE setLissHeight NOTIFY lissHeightChanged)
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
    int getStripWidth() const;
    void setStripWidth(const int width);
    int getStripHeight() const;
    void setStripHeight(const int height);
    int getCursorWidth() const;
    Q_INVOKABLE int getDrawPointList(const int chan, const int xavg_p);
    Q_INVOKABLE QPoint getPoint(const int i);
    Q_INVOKABLE QPoint getExpPoint(const int i);
    Q_INVOKABLE QPoint getLissPoint(const int i);
    Q_INVOKABLE int maxScale(const int height) const;
    Q_INVOKABLE int getCursorWidth(const int currentPix, const int expWidth);
    Q_INVOKABLE int pixToDpt(const int pix);
    Q_INVOKABLE int calExpPoints(const int chan, bool leftside);
    Q_INVOKABLE int calLissPoints(const int chan);
    int getExpTp() const;
    void setExpTp(int expTp);

    int getExpWidth() const;
    void setExpWidth(int expWidth);

    int getExpHeight() const;
    void setExpHeight(int expHeight);

    int getLissWidth() const;
    void setLissWidth(int lissWidth);

    int getLissHeight() const;
    void setLissHeight(int lissHeight);

    int getPt0() const;
    void setPt0(int Pt0);

    int getNpt() const;
    void setNpt(int Npt);

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
    QVector<QPoint> lPoints; //lissajous points
    QMap<int, int> m_point2PixMap;
    int m_scale, m_stripWidth, m_stripHeight;
    int m_cursorWidth;
    int m_expTp, m_expHeight, m_expWidth;
    int m_lissWidth, m_lissHeight;
    int m_Pt0, m_Npt;

};

#endif // TUBEHANDLER_H
