/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


#include <QtDBus/QtDBus>
#include <QtCore/QMetaType>
#include <QtCore/QVector>
#include <QtCore/QStringList>
#include "videodatabase.h"

#define GCONFKEY_RECENTRANGE "/MeeGo/Media/lastviewed-range-video"

VideoDatabase *VideoDatabase::videoDatabaseInstance = NULL;

VideoDatabase *VideoDatabase::instance()
{
    if (videoDatabaseInstance)
        return videoDatabaseInstance;
    else {
        videoDatabaseInstance = new VideoDatabase();
        return videoDatabaseInstance;
    }
}

VideoDatabase::VideoDatabase(QObject *parent)
    : MediaDatabase(GCONFKEY_RECENTRANGE, parent)
{
    trackeritems = 500;
    trackerindex = 0;
    targetitemtype = MediaItem::VideoItem;

    connect(this,SIGNAL(videoItemAdded(int)),this,SLOT(trackerVideoAdded(int)));
    connect(&thumb,SIGNAL(success(const MediaItem *)),this,SLOT(thumbReady(const MediaItem *)));

    qDebug() << "Initializing the database";
    trackerGetVideos(trackerindex, trackeritems);
}

VideoDatabase::~VideoDatabase()
{
    qDebug() << "~PhotoListModel";
}

void VideoDatabase::trackerAddItems(int type, QVector<QStringList> trackerreply, bool priority)
{
    QList<MediaItem *> newItemsList;

    if(type == MediaItem::VideoItem)
    {
        for (QVector<QStringList>::iterator i = trackerreply.begin(); i != trackerreply.end(); i++)
        {
            /* if this item is already in our list, skip it */
            if(mediaItemsUrnHash.contains((*i)[IDX_URN]))
                continue;

            QString url = (QUrl::fromEncoded((*i)[IDX_VID_URI].toAscii())).toLocalFile();
            QString mimetype = (*i)[IDX_VID_MIME];

            /* only create videoItems for files that exist */
            /* and are of type video */
            if (QFile::exists(url)&&(mimetype.startsWith("video")))
            {
                //qDebug() << "new video: " << (*i);
                MediaItem *item = new MediaItem(type, recenttime, *i);
                newItemsList << item;
                mediaItemsSidHash.insert(item->m_sid, item);
                mediaItemsUrnHash.insert(item->m_urn, item);
                mediaItemsIdHash.insert(item->m_id, item);
           }
        }
    }

    mediaItemsList += newItemsList;
    thumb.queueRequests(newItemsList);

    /* tell the world we have new data */
    emit itemsAdded(&newItemsList);

    /* if this data was specifically requested, send an alert */
    if(priority)
    {
        for(int i = 0; i < newItemsList.count(); i++)
            emit itemAvailable(newItemsList[i]->m_urn);
    }
}

void VideoDatabase::trackerGetVideos(const int offset, const int limit)
{
    //qDebug() << "MusicDatabase::trackerGetVideos";
    QString SqlCmd;
    switch(targetitemtype) {
    case MediaItem::VideoItem:
        SqlCmd = TRACKER_ALLVIDEOS;
        break;
    default:
        return;
    }

    QString sql = QString(SqlCmd).arg(QString().sprintf("%d", limit), QString().sprintf("%d", offset));
    //qDebug() << "Tracker Query: " << sql;

    QList<QVariant> argumentList;
    argumentList << qVariantFromValue(sql);
    QDBusPendingCall async = trackerinterface->asyncCallWithArgumentList(QLatin1String("SparqlQuery"), argumentList);
    QDBusPendingCallWatcher *watcher = new QDBusPendingCallWatcher(async, this);

    QObject::connect(watcher, SIGNAL(finished(QDBusPendingCallWatcher*)),
                     this, SLOT(trackerGetVideosFinished(QDBusPendingCallWatcher*)));
}

void VideoDatabase::trackerGetVideosFinished(QDBusPendingCallWatcher *call)
{
     QDBusPendingReply<QVector<QStringList> > reply = *call;

     /* no videos, either by error or end-of-query, quit */
     if (reply.isError()||reply.value().isEmpty()) {
         if(reply.isError())
            qDebug() << "QDBus Error: " << reply.error().message();
         return;
     }

     QVector<QStringList> videos = reply.value();
     trackerAddItems(targetitemtype, videos);

     /* generate the thumbnails after the items have been sent out */
     thumb.startLoop();

     /* go get more from tracker */
     trackerindex += trackeritems;
     trackerGetVideos(trackerindex, trackeritems);
}

void VideoDatabase::requestItem(QString urn)
{
    if(urn.startsWith("urn:"))
    {
        if(mediaItemsUrnHash.contains(urn))
        {
            emit itemAvailable(urn);
            return;
        }
    }
    else
    {
        QString uri = (QUrl::fromEncoded(urn.toAscii())).toString();
        for(int i = 0; i < mediaItemsList.count(); i++)
        {
            MediaItem *m = mediaItemsList[i];
            if(m->isAnyVideoType()&&(m->m_uri == uri))
            {
                emit itemAvailable(m->m_urn);
                return;
            }
        }
    }

    QString SqlCmd;
    if(urn.startsWith("urn:"))
        SqlCmd = TRACKER_VIDEO;
    else
        SqlCmd = TRACKER_VIDEO_URL;
    QString sql = QString(SqlCmd).arg(urn);

    QList<QVariant> argumentList;
    argumentList << qVariantFromValue(sql);
    QDBusPendingCall async = trackerinterface->asyncCallWithArgumentList(QLatin1String("SparqlQuery"), argumentList);
    QDBusPendingCallWatcher *watcher = new QDBusPendingCallWatcher(async, this);

    QObject::connect(watcher, SIGNAL(finished(QDBusPendingCallWatcher*)),
                     this, SLOT(trackerGetSingleFinished(QDBusPendingCallWatcher*)));
}

void VideoDatabase::trackerGetSingleFinished(QDBusPendingCallWatcher *call)
{
    QDBusPendingReply<QVector<QStringList> > reply = *call;

    /* no videos, either by error or end-of-query, quit */
    if (reply.isError()||reply.value().isEmpty()) {
        if(reply.isError())
           qDebug() << "QDBus Error: " << reply.error().message();
        return;
    }

    QVector<QStringList> videos = reply.value();
    trackerAddItems(MediaItem::VideoItem, videos, true);

    /* generate the thumbnails after the items have been sent out */
    thumb.startLoop();
}

void VideoDatabase::trackerVideoAdded(int sid)
{
    qDebug() << "trackerVideoAdded " << sid;
    QString SqlCmd = TRACKER_VIDEO_SID;
    QString sql = QString(SqlCmd).arg(sid);

    QVector<QStringList> info;
    if(trackerCall(info, sql))
        trackerAddItems(MediaItem::VideoItem, info);
}

/* high priority request from the view itself */
void VideoDatabase::requestThumbnail(MediaItem *item)
{
    thumb.requestImmediate(item);
}

void VideoDatabase::thumbReady(const MediaItem *item)
{
    QStringList temp;
    temp << item->m_id;
    emit itemsChanged(temp, VideoDatabase::Thumbnail);
}
