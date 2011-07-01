/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include "saverestorestate.h"

#include <QApplication>
#include <QDir>
#include <QList>
#include <QSettings>
#include <QSet>
#include <QTimer>
#include <time.h>

// There is only one SaveRestoreStatePrivate instance which provides
// the same QSettings instance as a backend for every SaveRestoreState.
class SaveRestoreStatePrivate
{
public:
    SaveRestoreStatePrivate();
    void                     init();
    bool                     shouldInit();

    QSettings               *settings;
    bool                     mustRestore;
    bool                     savingInProcess;
    struct timespec          savingStarted;
    QList<SaveRestoreState*> qList;
    QSet<SaveRestoreState*>  alwaysValid;
    QSet<SaveRestoreState*>  invalid;
    QSet<QString>            alreadyRestored;

    const QString            c_savingFinishedKey;
    const QString            c_elapsedTimeKey;
    const QString            c_lastSavedKey;
};

SaveRestoreStatePrivate::SaveRestoreStatePrivate() :
    settings(NULL), mustRestore(false), savingInProcess(false),
    c_savingFinishedKey("_SAVERESTORE_SAVING_FINISHED"),
    c_elapsedTimeKey("_SAVERESTORE_SAVING_TIME_MS"),
    c_lastSavedKey("_SAVERESTORE_LAST_SAVED_CLOCK_MONOTONIC_S")
{
    // Calling init is delayed until settings are really needed. Then
    // command line arguments are available, too. (If
    // invoker/applauncherd is used for starting up an application,
    // SaveRestoreState is constructed before knowing the arguments.)
}

void SaveRestoreStatePrivate::init()
{
    // Open / create the settings file
    QString base = QDir::homePath() + QDir::separator() + ".cache" +
        QDir::separator() + qApp->applicationName();
    QDir dir(base);
    if (!dir.exists()) {
        dir.mkpath(base);
    }
    settings = new QSettings(base + QDir::separator() + "saverestore.ini", QSettings::IniFormat);
    
    // Check command line arguments and saved settings: is restoring required?
    QStringList sl = qApp->arguments();
    if (sl.indexOf("--cmd") == sl.indexOf("restore") - 1)
    {
        // Application is not required to restore its state unless the
        // saved state is valid, that is, previous saving has been
        // finished.
        if (settings->value(c_savingFinishedKey) == true)
        {
            mustRestore = true;
        }
        else 
        {
            mustRestore = false;
        }
    }
    // Launching without restoring invalidates saved state. But even
    // if restoring is required, it's safest choice to
    // invalidate. Otherwise application could end up in
    // restore-crash-loop.
    settings->setValue(c_savingFinishedKey, false);
    settings->sync();
}

bool SaveRestoreStatePrivate::shouldInit()
{
    if (!qApp->property("preinit").toBool()) {
        if (!settings) init();
        return true;
    }
    return false;
}

SaveRestoreStatePrivate* SaveRestoreState::d = NULL;

SaveRestoreState::SaveRestoreState()
    :QObject(NULL)
{
    if (d == NULL) {
        d = new SaveRestoreStatePrivate();
    }
    d->qList.append(this);
}

SaveRestoreState::~SaveRestoreState()
{
    d->qList.removeOne(this);
    d->alwaysValid.remove(this);
    d->invalid.remove(this);
}

void SaveRestoreState::setValue(const QString &key, const QVariant &value)
{
    if (!d->shouldInit()) return;
    invalidate();
    d->settings->setValue(key, value);
}

QVariant SaveRestoreState::value(const QString &key, const QVariant &defaultValue) const
{
    if (!d->shouldInit()) return QVariant();
    return d->settings->value(key, defaultValue);
}

QStringList SaveRestoreState::allKeys() const
{
    if (!d->shouldInit()) return QStringList();
    return d->settings->allKeys();
}

void SaveRestoreState::sync()
{
    if (!d->shouldInit()) return;

    d->invalid.remove(this);

    if (d->invalid.isEmpty()) {
        // All not-alwaysValid SaveRestoreState instances have called
        // sync. Make the whole saved state valid and consider saving
        // process finished.
        d->settings->setValue(d->c_savingFinishedKey, true);
        d->savingInProcess = false;
        
        // Store saving time and timestamp.
        struct timespec savingFinished;
        clock_gettime(CLOCK_MONOTONIC, &savingFinished);
        long timediff_ms = 
            (savingFinished.tv_sec * 1000 + savingFinished.tv_nsec / 1000000)
            - (d->savingStarted.tv_sec * 1000 + d->savingStarted.tv_nsec / 1000000);
        d->settings->setValue(d->c_elapsedTimeKey, static_cast<long long>(timediff_ms));
        d->settings->setValue(d->c_lastSavedKey, static_cast<long long>(savingFinished.tv_sec));
        d->settings->sync();

        // TODO: after the final sync and flushing io buffers, do the
        // atomic trick: rename the file with the correct saverestore
        // file name. Invalidate should correspondingly unlink the
        // file. The current approach might still cause failure in
        // case of sudden power off or sigkill.
    }
}

QVariant SaveRestoreState::restoreOnce(const QString &key, const QVariant &defaultValue)
{
    if (!d->shouldInit()) return QVariant();
    if (!d->mustRestore || d->alreadyRestored.contains(key))
    {
        return defaultValue;
    } else {
        d->alreadyRestored.insert(key);
        return value(key, defaultValue);
    }
}

QVariant SaveRestoreState::restoreOnceAndRemove(const QString &key, const QVariant &defaultValue)
{
    if (!d->shouldInit()) return QVariant();
    QVariant ret = restoreOnce(key, defaultValue);
    if (d->alreadyRestored.contains(key))
    {
      d->settings->remove(key);
    }
    return ret;
}

void SaveRestoreState::remove(const QString &key)
{
    if(!d->shouldInit()) return;
    d->settings->remove(key);
}

void SaveRestoreState::setAlwaysValid(bool alwaysValid_)
{
    if (d->alwaysValid.contains(this)) {
        // Setting this property back and forth especially during
        // state saving leads into difficulties on deciding when the
        // saved state is consistent and when it's not. Current
        // solution: just don't do it!
        qFatal("SaveRestoreState instance must not change alwaysValid value.");
    }
    if (alwaysValid_) {
        d->alwaysValid.insert(this);
        if (d->invalid.contains(this)) d->invalid.remove(this);
    }
}

bool SaveRestoreState::alwaysValid()
{
    return d->alwaysValid.contains(this);
}

void SaveRestoreState::invalidate()
{
    if (!d->shouldInit()) return;

    if (!d->savingInProcess)
    {
        d->settings->setValue(d->c_savingFinishedKey, false);
        d->settings->sync();
        d->savingInProcess = true;
    }

    if (!d->alwaysValid.contains(this)) {
        d->invalid.insert(this);
    }
}

bool SaveRestoreState::restoreRequired() const
{
    if (!d->shouldInit()) return false;
    return d->mustRestore;
}

void SaveRestoreState::requireSaveAll()
{
    // Invalidate all instances before requesting saving. Otherwise,
    // there would be short periods of time when saved state is
    // consistent without all being saved.
    clock_gettime(CLOCK_MONOTONIC, &(d->savingStarted));
    Q_FOREACH(SaveRestoreState *q, d->qList) {
        q->invalidate();
    }
    Q_FOREACH(SaveRestoreState *q, d->qList) {
        q->requireSave();
    }
}

void SaveRestoreState::requireSave()
{
    emit saveRequired();
}
