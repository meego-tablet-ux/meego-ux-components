#ifndef FAVORITEAPPLICATIONSMODEL_H
#define FAVORITEAPPLICATIONSMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include <QFileSystemWatcher>
#include <QObject>
#include <QHash>
#include <QStringList>
#include <QSettings>
#include <QTimer>

#include "desktop.h"


class FavoriteApplicationsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit FavoriteApplicationsModel(QObject *parent = 0);
    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
    virtual QVariant data(const QModelIndex &index, int role) const;

    Q_INVOKABLE void append(QString filename);

private slots:
    void readSettings();
    void writeSettings();
    void clearModel();
    void fullReset();
    //out of box experience init
    void oobeInit();

private:

    void delayedReset();
    QStringList m_desktopFiles;
    QList<Desktop *> m_favorites;
    QHash<QString,QVariant> m_popularityRating;
    QFileSystemWatcher *m_SettingFileWatcher;
    QSettings*  m_readSettings;
};

#endif // RECENTAPPLICATIONSMODEL_H
