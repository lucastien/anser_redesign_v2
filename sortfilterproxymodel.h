#ifndef SORTFILTERPROXYMODEL_H
#define SORTFILTERPROXYMODEL_H

#include <QQmlParserStatus>
#include <QSortFilterProxyModel>
#include <QRegExp>
#include "diskitem.h"

class SortFilterProxyModel : public QSortFilterProxyModel, public QQmlParserStatus
{
    Q_OBJECT

    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QObject *source READ source WRITE setSource)

    Q_PROPERTY(QString diskIdFilterString READ diskIdFilterString WRITE setDiskIdFilterString)
    Q_PROPERTY(QString sgFilterString READ sgFilterString WRITE setSGFilterString)
    Q_PROPERTY(QString legFilterString READ legFilterString WRITE setLegFilterString)
    Q_PROPERTY(QString alphaFilterString READ alphaFilterString WRITE setAlphaFilterString)
    Q_PROPERTY(QString reelFilterString READ reelFilterString WRITE setReelFilterString)
    Q_PROPERTY(QString unitFilterString READ unitFilterString WRITE setUnitFilterString)

public:

    explicit SortFilterProxyModel(QObject *parent = nullptr);


    QObject *source() const;
    void setSource(QObject *source);


    QByteArray filterRole() const;
    void setFilterRole(const QByteArray &role);

    QString diskIdFilterString() const;
    void setDiskIdFilterString(const QString &filter);

    QString sgFilterString() const;
    void setSGFilterString(const QString &filter);

    QString unitFilterString() const;
    void setUnitFilterString(const QString &filter);

    QString legFilterString() const;
    void setLegFilterString(const QString &filter);

    QString reelFilterString() const;
    void setReelFilterString(const QString &filter);

    QString alphaFilterString() const;
    void setAlphaFilterString(const QString &filter);
    Q_INVOKABLE QVariantMap get(int row);
    // QAbstractProxyModel interface
public:
    // QQmlParserStatus interface
    void classBegin() override;
    void componentComplete() override;
    // QSortFilterProxyModel interface
protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;
    int roleKey(const QByteArray &role) const;
private:
    QByteArray m_filterRole;
    bool m_complete;
    QRegExp diskRegExp;
    QRegExp sgRegExp;
    QRegExp legRegExp;
    QRegExp alphaRegExp;
    QRegExp reelRegExp;
    QRegExp unitRegExp;
};

#endif // SORTFILTERPROXYMODEL_H
