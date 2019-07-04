#ifndef CHANNELHANDLER_H
#define CHANNELHANDLER_H

#include <QObject>

class ChannelHandler : public QObject
{
    Q_PROPERTY(int getSpan READ getSpan WRITE setSpan NOTIFY spanChanged)
    Q_PROPERTY(int getRot READ getRot WRITE setRot NOTIFY rotChanged)
    Q_OBJECT
public:
    explicit ChannelHandler(QObject *parent = nullptr);

    int getSpan() const;
    void setSpan(int getSpan);

    int getRot() const;
    void setRot(int getRot);

signals:
    void spanChanged();
    void rotChanged();
public slots:

private:
    int m_span, m_rot;
};

#endif // CHANNELHANDLER_H
