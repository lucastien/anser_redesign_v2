#include "reelinfomodel.h"
#include "global.h"
const int MaxColumn = 9;

ReelInfoModel::ReelInfoModel(QObject *parent): QAbstractTableModel (parent)
{

}


int ReelInfoModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return reelInfoItems.size();
}

int ReelInfoModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return MaxColumn;
}

QVariant ReelInfoModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() || index.row() < 0 || index.row() >= reelInfoItems.count()||
            index.column() < 0 || index.column() >= MaxColumn)
        return QVariant();
    const ReelInfoItem & reelItem = reelInfoItems.at(index.row());
    switch (role) {
    case Indexed: return reelItem.indexed;
    case Entry: return reelItem.entry;
    case SG: return reelItem.sg;
    case Row: return reelItem.row;
    case Col: return reelItem.col;
    case Time: return reelItem.time;
    case Length: return reelItem.length;
    case QA: return reelItem.qa;
    case RPT: return reelItem.rpt;
    }
    return QVariant();
}

QHash<int, QByteArray> ReelInfoModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int index = Indexed;
    foreach(const QString& roleName, reelInfoRoleList){
        roles[index++] = roleName.toUtf8();
    }

    return roles;
}

void ReelInfoModel::addItems(const QVector<ReelInfoItem> &items)
{
    beginResetModel();
    reelInfoItems = items;
    endResetModel();
}

QString ReelInfoModel::get(int row)
{

    if(reelInfoItems.empty()) return QString();
    if(row < 0 || row >= reelInfoItems.size()) return QString();
    const ReelInfoItem & reelItem = reelInfoItems.at(row);

    return reelItem.fileName;
}

void ReelInfoModel::markIndexed(int row, int col, bool marked)
{
   const QModelIndex& modelIndex = index(row, col);
   setData(modelIndex, marked, Indexed);
}


bool ReelInfoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(role == Indexed){
        reelInfoItems[index.row()].indexed = value.toBool();
        QModelIndex left = this->index(index.row(), 0);
        QModelIndex right = this->index(index.row(), columnCount(QModelIndex()) - 1);

       emit dataChanged(left, right);
       return true;
    }
    return false;
}
