#include "disktablemodel.h"
#include "global.h"
#include <QFontMetrics>
#include <QGuiApplication>

const int MaxColumns = 6;

DiskTableModel::DiskTableModel(QObject *parent): QAbstractTableModel (parent)
{

}


int DiskTableModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return diskItems.count();
}

int DiskTableModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return MaxColumns;
}

QVariant DiskTableModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() ||
            index.row() < 0 || index.row() >= diskItems.count() ||
            index.column() < 0 || index.column() >= MaxColumns)
        return QVariant();
    const DiskItem & diskItem = diskItems.at(index.row());
    switch (role) {
    case Column::Reel: return diskItem.reel;
    case Column::DiskID: return diskItem.diskId;
    case Column::SG: return diskItem.sg;
    case Column::Leg: return diskItem.leg;
    case Column::Unit: return diskItem.unit;
    case Column::Alpha: return diskItem.alpha;
    default: return QVariant();
    }
}

void DiskTableModel::addItem(const DiskItem &item)
{
    diskItems.push_back(item);
}

void DiskTableModel::addItems(const QList<DiskItem> &items)
{
    beginResetModel();
    diskItems = items;
    endResetModel();
}

void DiskTableModel::updateModel()
{
    emit dataChanged(index(0,0), index(diskItems.count() - 1, MaxColumns - 1));
}


QVariant DiskTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role != Qt::DisplayRole)
        return QVariant();
    if (orientation == Qt::Horizontal) {
        switch (section) {
        case Column::Reel: return tr("Reel");
        case Column::DiskID: return tr("DiskID");
        case Column::SG: return tr("SG");
        case Column::Leg: return tr("L");
        case Column::Unit: return tr("Unit");
        case Column::Alpha: return tr("Alpha");
        default: Q_ASSERT(false);
        }
    }
    return section + 1;
}

int DiskTableModel::columnWidth(int column)
{
    QFontMetrics defaultFontMetrics = QFontMetrics(QGuiApplication::font());
    int ret = defaultFontMetrics.width(headerData(column, Qt::Horizontal).toString()) + 25;
    return ret;
}


QHash<int, QByteArray> DiskTableModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int index = Reel;
    foreach(const QString& role, diskRoleList){
        roles[index++] = role.toUtf8();
    }
    return roles;
}
