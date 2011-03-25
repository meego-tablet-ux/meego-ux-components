/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


#ifndef MUSICDATABASE_H
#define MUSICDATABASE_H

#include "mediadatabase.h"
#include "mediaitem.h"
#include "mediainfodownloader.h"

class MusicDatabase : public MediaDatabase {
    Q_OBJECT

public:
    static MusicDatabase *instance();
    MusicDatabase(QObject *parent = 0);
    ~MusicDatabase();

    void requestThumbnail(MediaItem *item);
    void requestItem(int type, QString urn);
    void savePlaylist(QList<MediaItem *> &list, const QString &title);
    QList<MediaItem *> loadPlaylist(const QString &title);
    MediaItem* getArtistItem(const QString &title);

public slots:
    void trackerSongAdded(int sid);
    void trackerPlaylistAdded(int sid);
    void trackerGetMusicFinished(QDBusPendingCallWatcher *call);
    void trackerGetSongFinished(QDBusPendingCallWatcher *call);
    void trackerGetAlbumFinished(QDBusPendingCallWatcher *call);
    void trackerGetArtistFinished(QDBusPendingCallWatcher *call);
    void trackerGetPlaylistFinished(QDBusPendingCallWatcher *call);

private slots:
    void error(QString reqid, QString type, QString info, QString errorString);
    void ready(QString reqid, QString type, QString info, QString data);
    void startThumbnailerLoop();

private:
    static MusicDatabase *musicDatabaseInstance;

    MediaInfoDownloader mediaart;
    bool disable_mediaart;

    /* tracker calls */
    void trackerGetMusic(const int offset, const int limit);
    void processSong(MediaItem *item);
    void enforceUniqueTitles(MediaItem *item);
    void trackerAddItems(int type, QVector<QStringList> trackerreply, bool priority=false);
    MediaItem* getAlbumItem(QString artist, QString album);
    /* unique title variables */
    QHash<QString, int> titleCountHash;
    void createPlaylistThumb(QList<MediaItem *> &list, const QString &title);
    void generatePlaylistThumbId(MediaItem *item);
    int playlistthumbid;

    /* music database hashes for easy lookup */
    QHash<QString, MediaItem *> artistItemHash;
};

#endif // MUSICDATABASE_H
