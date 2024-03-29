#ifndef CHANNEL_H
#define CHANNEL_H

#include <QObject>
#include <QString>
#include <QVector>
#include <QPoint>
#include <QSharedPointer>
#include "channelparam.h"

class Channel : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(QString fullName READ getFullName NOTIFY fullNameChanged)
    Q_PROPERTY(int rot READ getRot WRITE setRot NOTIFY rotChanged)
    Q_PROPERTY(int span READ getSpan WRITE setSpan NOTIFY spanChanged)
    Q_PROPERTY(float vcon READ getVcon WRITE setVcon NOTIFY vconChanged)
    Q_PROPERTY(int freq READ getFreq WRITE setFreq NOTIFY freqChanged)
public:
    explicit Channel(const QString& name_ = QString());
    ~Channel();
    void add(const short x, const short y);
    void clear();
    const QPoint &at(const int i) const;
    ChannelParam &getCp();
    const QVector<QPoint> &getData() const;
    QString getName() const;
    void setName(const QString &Name);
    int getRot() const;
    void setRot(int rot_);
    int getSpan() const;
    void setSpan(int span);
    int getRawNpt() const;
    void setRawNpt(int rawNpt);
    float getVcon() const;
    void setVcon(float vcon);
    QString getDataSetId() const;
    void setDataSetId(const QString &dataSetId);

    QString getFullName() const;
    void setFullName(const QString &fullName);

    int getFreq() const;
    void setFreq(int freq);

signals:
    void rotChanged();
    void spanChanged();
    void vconChanged();
    void freqChanged();
    void fullNameChanged();
private:
    QString m_Name;
    QString m_fullName;
    QString m_dataSetId;
    int m_freq;
    QVector<QPoint> m_Data;
    int m_rawNpt;
    ChannelParam cp;
};
//Q_DECLARE_METATYPE(Channel*)
typedef QSharedPointer<Channel> ChannelPtr;
#endif // CHANNEL_H
