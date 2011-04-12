/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


#include <QDir>
#include <QDebug>
#include "thumbnailer.h"

#define TUMBLER_SERVICE       "org.freedesktop.thumbnails.Thumbnailer1"
#define TUMBLER_PATH          "/org/freedesktop/thumbnails/Thumbnailer1"
#define TUMBLER_INTERFACE     "org.freedesktop.thumbnails.Thumbnailer1"
#define DEFAULT_SCHEDULER     "foreground"
#define THUMBNAILITEMS        1
#define THUMBNAILPAUSE        5000

Thumbnailer::Thumbnailer(QObject *parent)
    : QObject(parent)
{
    thumbnailerlooppause = false;
    thumbnailerinuse = false;
    connect(&thumbnailerTimer, SIGNAL(timeout()), this, SLOT(thumbnailerResumeLoop()));

    tumblerinterface = new QDBusInterface(TUMBLER_SERVICE, TUMBLER_PATH, TUMBLER_INTERFACE);

    QDBusConnection::sessionBus().connect(TUMBLER_SERVICE, TUMBLER_PATH, TUMBLER_INTERFACE,
        "Ready", this, SLOT(tumblerReady(const unsigned int, const QStringList)));
    QDBusConnection::sessionBus().connect(TUMBLER_SERVICE, TUMBLER_PATH, TUMBLER_INTERFACE,
        "Error", this, SLOT(tumblerError(const unsigned int, const QStringList, \
                                                const int, const QString )));
    QDBusConnection::sessionBus().connect(TUMBLER_SERVICE, TUMBLER_PATH, TUMBLER_INTERFACE,
        "Finished", this, SLOT(tumblerFinished(const unsigned int)));
}

Thumbnailer::~Thumbnailer()
{
}

bool Thumbnailer::isValid(MediaItem *item)
{
    /* it has no thumbnail already, and its */
    /* thumbnail hasn't already tried and failed, */
    /* and it's a photo or video file */
    if(!item->m_thumburi_exists&&
       !item->m_thumburi_ignore&&
       (item->isPhoto()||item->isAnyVideoType()))
    {
        return true;
    }
    return false;
}

void Thumbnailer::queueRequest(MediaItem *item)
{
    if(isValid(item)&&!queue.contains(item))
    {
        queue << item;
        //qDebug() << "Tumbler Queueing: " <<  item->m_uri;
    }
}

void Thumbnailer::queueRequests(QList<MediaItem *> &items)
{
    for(int i = 0; i < items.count(); i++)
        queueRequest(items[i]);
}

void Thumbnailer::startLoop()
{
    /* if it's already running or paused, leave */
    if(thumbnailerinuse||thumbnailerlooppause)
        return;

    /* create a list of uris/mimetypes for the tumbler call */
    QStringList uris, mimetypes;

    for(int i = 0; (i < queue.count())&&(uris.count() < THUMBNAILITEMS); i++)
    {
        uris << queue[i]->m_uri;
        mimetypes << queue[i]->m_mimetype;
    }

    if(!uris.isEmpty())
    {
        quint32 handle = 0;
        //qDebug() << "Tumbler Loop Requesting " <<  THUMBNAILITEMS << " Thumbnails: " << uris;
        thumbnailerinuse = true;
        tumblerinterface->asyncCall(QLatin1String("Queue"), uris, mimetypes,
            DEFAULT_FLAVOR, DEFAULT_SCHEDULER, handle);
    }
}

/* high priority request from the view itself */
void Thumbnailer::requestImmediate(MediaItem *item)
{
    QStringList uris, mimetypes;
    if(isValid(item))
    {
        if(!queue.contains(item))
            queue << item;
        //qDebug() << "requestImmediate: " << item->m_uri;
        thumbnailerlooppause = true;
        thumbnailerTimer.stop();
        thumbnailerTimer.start(THUMBNAILPAUSE);
        uris << item->m_uri;
        mimetypes << item->m_mimetype;
        quint32 handle = 0;
        tumblerinterface->asyncCall(QLatin1String("Queue"), uris, mimetypes,
            DEFAULT_FLAVOR, DEFAULT_SCHEDULER, handle);
    }
}

void Thumbnailer::thumbnailerResumeLoop()
{
    //qDebug() << "thumbnailerResumeLoop";
    thumbnailerTimer.stop();
    thumbnailerlooppause = false;
    thumbnailerinuse = false;
    startLoop();
}


void Thumbnailer::tumblerFinished(const unsigned int &handle)
{
    Q_UNUSED( handle );
    //qDebug() << "Tumbler Finished: " << handle;
    thumbnailerinuse = false;
    if(!thumbnailerlooppause)
        startLoop();
}

void Thumbnailer::tumblerReady(const unsigned int &handle, const QStringList &urls)
{
    Q_UNUSED( handle );
    //qDebug() << "Tumbler Ready: " << handle << urls;
    QList<MediaItem *> removeList;

    for(int i = 0; i < queue.count(); i++)
    {
        if(urls.contains(queue[i]->m_uri))
        {
            queue[i]->m_thumburi_exists = true;
            queue[i]->m_thumburi_ignore = false;
            removeList << queue[i];
            emit success(queue[i]);
            //qDebug() << "thumbnail online " << queue[i]->m_thumburi;
        }
    }

    for(int i = 0; i < removeList.count(); i++)
        queue.removeAll(removeList[i]);
}

void Thumbnailer::tumblerError(const unsigned int &handle, const QStringList &urls, const int &errorCode, const QString &message)
{
    qDebug() << "Tumbler Error: " << handle << urls << errorCode << message;
    QList<MediaItem *> removeList;

    for(int i = 0; i < queue.count(); i++)
    {
        if(urls.contains(queue[i]->m_uri))
        {
            queue[i]->m_thumburi_exists = false;
            queue[i]->m_thumburi_ignore = true;
            removeList << queue[i];
            emit failure(queue[i]);
            //qDebug() << "thumbnail failed " << queue[i]->m_thumburi;
        }
    }

    for(int i = 0; i < removeList.count(); i++)
        queue.removeAll(removeList[i]);
}
