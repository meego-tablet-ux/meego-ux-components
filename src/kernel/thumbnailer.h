/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


#ifndef THUMBNAILER_H
#define THUMBNAILER_H

#include <QAbstractListModel>
#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QtDBus/QtDBus>
#include "mediaitem.h"

class Thumbnailer: public QObject
{
    Q_OBJECT

public:
    Thumbnailer(QObject *parent = 0);
    ~Thumbnailer();

    void startLoop();
    void queueRequest(MediaItem *item);
    void queueRequests(QList<MediaItem *> &items);
    void requestImmediate(MediaItem *item);

public slots:
    void tumblerReady(const unsigned int &handle, const QStringList &urls);
    void tumblerFinished(const unsigned int &handle);
    void tumblerError(const unsigned int &handle, const QStringList &urls, const int &errorCode, const QString &message);
    void thumbnailerResumeLoop();

signals:
    void success(const MediaItem *item);
    void failure(const MediaItem *item);

private:
    QList<MediaItem *> queue;
    QTimer thumbnailerTimer;
    bool thumbnailerlooppause;
    bool thumbnailerinuse;

    bool isValid(MediaItem *item);
    /* tumbler calls */
    QDBusInterface *tumblerinterface;
    void tumblerGetThumbnails(const QStringList &filePaths, const QStringList &mimetypes);
    void startThumbnailerLoop();
};

#endif // THUMBNAILER_H
