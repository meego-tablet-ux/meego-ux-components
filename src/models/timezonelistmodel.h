#ifndef TIMEZONELISTMODEL_H
#define TIMEZONELISTMODEL_H

#include <QAbstractListModel>
#include <kcalcoren/ksystemtimezone.h>

class TimezoneListModel: public QAbstractListModel
{
    Q_OBJECT

public:
    TimezoneListModel(QObject *parent = 0);
    ~TimezoneListModel();

    enum Role {
        Title = Qt::UserRole + 1,
        City = Qt::UserRole + 2,
        GMTOffset = Qt::UserRole + 3,
        Latitude = Qt::UserRole + 4,
        Longitude = Qt::UserRole + 5,
        CountryCode = Qt::UserRole + 6,
        Index = Qt::UserRole + 7
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

public slots:
    void filterOut(QString filter);

protected:
    QString getCity(QString title) const;
    KSystemTimeZones zones;
    QList<KTimeZone> itemsList;
    QList<KTimeZone*> itemsDisplay;
};

#endif // TIMEZONELISTMODEL_H
