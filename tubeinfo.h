#ifndef TUBEINFO_H
#define TUBEINFO_H

#include <QObject>
#include <QString>

class TubeInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int row READ row WRITE setRow NOTIFY rowChanged)
    Q_PROPERTY(int col READ col WRITE setCol NOTIFY colChanged)
    Q_PROPERTY(int reel READ reel WRITE setReel NOTIFY reelChanged)
    Q_PROPERTY(QString leg READ leg WRITE setLeg NOTIFY legChanged)
    Q_PROPERTY(int unit READ unit WRITE setUnit NOTIFY unitChanged)
    Q_PROPERTY(QString sg READ sg WRITE setSg NOTIFY sgChanged)
    Q_PROPERTY(QString alpha READ alpha WRITE setAlpha NOTIFY alphaChanged)
    Q_PROPERTY(QString diskId READ diskId WRITE setDiskId NOTIFY diskIdChanged)

public:
    explicit TubeInfo(QObject *parent = nullptr);

    int row() const;
    void setRow(int row);

    int col() const;
    void setCol(int col);

    int reel() const;
    void setReel(int reel);

    int unit() const;
    void setUnit(int unit);

    QString sg() const;
    void setSg(const QString &sg);

    QString leg() const;
    void setLeg(const QString &leg);

    QString alpha() const;
    void setAlpha(const QString &alpha);

    QString diskId() const;
    void setDiskId(const QString &diskId);

signals:
    void rowChanged();
    void colChanged();
    void reelChanged();
    void legChanged();
    void unitChanged();
    void sgChanged();
    void alphaChanged();
    void diskIdChanged();

private:
    int m_row, m_col, m_reel, m_unit;
    QString m_sg, m_leg, m_alpha, m_diskId;
};

#endif // TUBEINFO_H
