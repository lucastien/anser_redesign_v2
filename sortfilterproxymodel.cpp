#include "sortfilterproxymodel.h"
#include <QDebug>

SortFilterProxyModel::SortFilterProxyModel(QObject *parent): QSortFilterProxyModel (parent), m_complete(false)
{
    diskRegExp.setCaseSensitivity(Qt::CaseInsensitive);
    diskRegExp.setPatternSyntax(QRegExp::Wildcard);
    sgRegExp.setCaseSensitivity(Qt::CaseInsensitive);
    sgRegExp.setPatternSyntax(QRegExp::Wildcard);
    legRegExp.setCaseSensitivity(Qt::CaseInsensitive);
    legRegExp.setPatternSyntax(QRegExp::Wildcard);
    alphaRegExp.setCaseSensitivity(Qt::CaseInsensitive);
    alphaRegExp.setPatternSyntax(QRegExp::Wildcard);
}

QObject *SortFilterProxyModel::source() const
{
    return sourceModel();
}

void SortFilterProxyModel::setSource(QObject *source)
{
    setSourceModel(qobject_cast<QAbstractItemModel *>(source));
}

bool SortFilterProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    bool filteredDisk = true;
    bool filteredSg = true;
    bool filteredLeg = true;
    bool filteredAlpha = true;
    QAbstractItemModel *model = sourceModel();
    if(model == nullptr){
        qDebug() << "Not found model";
        return true;
    }

    if(!diskRegExp.isEmpty()){
        QModelIndex diskIndex = model->index(source_row, 0, source_parent);
        if (diskIndex.isValid()){
            QString key = model->data(diskIndex, roleKey("diskId")).toString();
            filteredDisk = key.contains(diskRegExp);
        }
    }


    if(!sgRegExp.isEmpty()){
        QModelIndex sgIndex = model->index(source_row, 0, source_parent);
        if (sgIndex.isValid()){
            QString key = model->data(sgIndex, roleKey("sg")).toString();
            filteredSg = key.contains(sgRegExp);
        }
    }

    if(!legRegExp.isEmpty()){
        QModelIndex legIndex = model->index(source_row, 0, source_parent);
        if (legIndex.isValid()){
            QString key = model->data(legIndex, roleKey("leg")).toString();
            filteredLeg = key.contains(legRegExp);
        }

    }

    if(!alphaRegExp.isEmpty()){
        QModelIndex alphaIndex = model->index(source_row, 0, source_parent);
        if (alphaIndex.isValid()){
            QString key = model->data(alphaIndex, roleKey("alpha")).toString();
            filteredAlpha = key.contains(alphaRegExp);
        }
    }
    return filteredDisk && filteredSg && filteredLeg && filteredAlpha;

}

int SortFilterProxyModel::roleKey(const QByteArray &role) const
{
    QHash<int, QByteArray> roles = roleNames();
    QHashIterator<int, QByteArray> it(roles);
    while (it.hasNext()) {
        it.next();
        if (it.value() == role)
            return it.key();
    }
    return -1;
}




void SortFilterProxyModel::setFilterRole(const QByteArray &role)
{
    if (m_filterRole != role) {
        m_filterRole = role;
        if (m_complete)
            QSortFilterProxyModel::setFilterRole(roleKey(role));
    }
}

QString SortFilterProxyModel::diskIdFilterString() const
{
    return diskRegExp.pattern();
}
void SortFilterProxyModel::setDiskIdFilterString(const QString &filter)
{
    diskRegExp.setPattern(filter);
    invalidateFilter();
}
QString SortFilterProxyModel::sgFilterString() const
{
    return sgRegExp.pattern();
}
void SortFilterProxyModel::setSGFilterString(const QString &filter)
{
    sgRegExp.setPattern(filter);
    invalidateFilter();
}

QString SortFilterProxyModel::unitFilterString() const
{
    return unitRegExp.pattern();
}

void SortFilterProxyModel::setUnitFilterString(const QString &filter)
{
    unitRegExp.setPattern(filter);
    invalidateFilter();
}

QString SortFilterProxyModel::legFilterString() const
{
    return legRegExp.pattern();
}
void SortFilterProxyModel::setLegFilterString(const QString &filter)
{
    legRegExp.setPattern(filter);
    invalidateFilter();
}

QString SortFilterProxyModel::reelFilterString() const
{
    return reelRegExp.pattern();
}

void SortFilterProxyModel::setReelFilterString(const QString &filter)
{
    reelRegExp.setPattern(filter);
    invalidateFilter();
}

QString SortFilterProxyModel::alphaFilterString() const
{
    return alphaRegExp.pattern();
}
void SortFilterProxyModel::setAlphaFilterString(const QString &filter)
{
    alphaRegExp.setPattern(filter);
    invalidateFilter();
}

QVariantMap SortFilterProxyModel::get(int row)
{
    QHash<int,QByteArray> names = roleNames();
    QHashIterator<int, QByteArray> i(names);
    QVariantMap res;
    while (i.hasNext()) {
        i.next();
        QModelIndex idx = index(row, 0);
        QVariant data = idx.data(i.key());
        res[i.value()] = data;

    }
    return res;
}




void SortFilterProxyModel::classBegin()
{
}

void SortFilterProxyModel::componentComplete()
{
    m_complete = true;
    if (!m_filterRole.isEmpty())
        QSortFilterProxyModel::setFilterRole(roleKey(m_filterRole));

}
