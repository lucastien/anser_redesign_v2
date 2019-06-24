#ifndef DISKTABLEMODEL_H
#define DISKTABLEMODEL_H

#include "diskitem.h"
#include <QAbstractTableModel>



class DiskTableModel : public QAbstractTableModel
{    
    Q_OBJECT
public:
    enum Column{
        Reel = Qt::UserRole+1,
        DiskID,
        SG,
        Leg,
        Unit,
        Alpha
    };
    explicit DiskTableModel(QObject *parent = nullptr);

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    int columnCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    void addItem(const DiskItem& item);
    void addItems(const QList<DiskItem>& items);
    void updateModel();
private:
    QList<DiskItem> diskItems;

    // QAbstractItemModel interface
public:
    Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE int columnWidth(int column);

    // QAbstractItemModel interface
public:
    QHash<int, QByteArray> roleNames() const override;
};

#endif // DISKTABLEMODEL_H
