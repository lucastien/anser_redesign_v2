#ifndef REELINFOMODEL_H
#define REELINFOMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include "reellistitem.h"

class ReelInfoModel: public QAbstractTableModel
{
    Q_OBJECT
public:
    enum Column{
        Indexed = Qt::UserRole + 1,
        Entry,
        SG,
        Row,
        Col,
        Time,
        Length,
        QA,
        RPT
    };
    explicit ReelInfoModel(QObject *parent = nullptr);

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    void addItems(const QVector<ReelInfoItem>& items);
    Q_INVOKABLE QString get(int row);
    Q_INVOKABLE void markIndexed(int row, int col, bool marked);
private:
    QVector<ReelInfoItem> reelInfoItems;

    // QAbstractItemModel interface
public:
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
};

#endif // REELINFOMODEL_H
