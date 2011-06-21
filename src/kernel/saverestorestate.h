/* -*- mode: c++ -*-
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass SaveRestoreState
  \title SaveRestoreState

  \section1 Purpose
  Minimized applications are in many cases doing nothing while the
  user is not interacting with them.  From time to time, system
  resources can become scarce.

  The SaveRestoreState allows for applications to persist and recover
  their internal state so that they can be killed and restarted with
  no visible difference to the user.

  The SaveRestoreState does not kill applications.  It only gives
  applications a set of tools to persist and recover their state.

  \section2 Considerations

  One must carefully consider the necessary information that is
  required to properly resume an application.  While much of the data
  for an application is usually persisted in a back-end (for example,
  a PIM database), there is often unconsidered presentation state
  information.  If, for example, a dialog is open, it would be
  expected for the same dialog to be open when the application is
  restored.  Developers must be careful to note when they are adding
  presentation layer state and when it is reasonable to persist such
  information.

  Of course, some presentation state need not be
  persisted.  If such information relates to a transient condition that
  will be invalid when the application is restored, such state is best
  skipped.  One such example is a dialog of a connection timeout.

  \section2 Other information
  The save/restore information is currently being saved at
  /home/meego/.cache/name-of-app/saverestore.ini. This file is per-
  application (therefore, different applications do not have to worry
  about namespace collision with each other). The saveRequired signal
  is normally called 0.5 seconds after the application has been
  minimized or sent to be background. To test an application's restore
  functionality, run the application via meego-qml-launcher and with
  the argument "--cmd restore" (no quotes).

  \section1 SaveRestoreState
  SaveRestoreState emits saveRequired when the application should save
  its state. This signal is emitted when the application is no longer
  the in the foreground.  State is saved using setValue(key, value)
  and by finally calling sync().

  The restoreRequired property is true if the application should
  restore its saved state. The value will not change when the
  application is running. value(key[, defaultValue]) returns saved
  values.

  The saveRequired signal is emitted from all SaveRestoreState
  instances typically when the application is minimized. The
  application can synthesize the signals by calling requireSave and
  requireSaveAll in order to emit signals from a single or from all
  SaveRestoreState instances.

  If a SaveRestoreState instance will not store any data or react on
  saveRequired at all, its alwaysValid property must be set to
  true. An alwaysValid instance does not need to call sync() after
  being required to save. The instance can still be used for reading
  the restoreRequired value or triggering the state saving.

  The application will be required to restore its state only if the
  state is consistent. Saved state becomes consistent when all
  SaveRestoreState instances whose alwaysValid is false have called
  sync(). State becomes inconsistent when on saveRequired, or when the
  application calls setValue() or invalidate().

  \section2 API Properties
    \qmlproperty bool restoreRequired
    \qmlcm true if application is required to restore its state on
    startup.
           Value is read-only and it will not change when the
           application process is running.

    \qmlproperty bool alwaysValid
    \qmlcm true if excluded from consistency check.
           The default value is false. Must be set to true if the
           SaveRestoreState instance will never call sync(). If so, it
           is highly recommended to never call setValue() either.
           Otherwise, if state saving is interrupted by a crash or a
           kill, application may be required to restore an
           inconsistent state.

  \section2 Signals
    \qmlfn saveRequired
    \qmlcm emitted when application is required to save its state.
           Unless SaveRestoreState instance is alwaysValid, it is
           expected to call sync() when saving has been finished on
           its part.

  \section2 Functions
    \qmlfn setValue
    \qmlcm stores value with the key.
       \param QString key
       \param QVariant value
       \endparam

    \qmlfn value
    \qmlcm returns the value stored with the key in a form of a string.
           If no value has been stored with the key, returns the
           default value.
       \param QString key
       \param QVariant defaultValue (optional)
       \qmlcm if not given, defaultValue defaults to QVariant().\endparam

    \qmlfn allKeys
    \qmlcm returns a list of all keys with same semantics as
           QSettings::allKeys

    \qmlfn restoreOnce
    \qmlcm returns either value stored with the key or defaultValue.
               Stored value is returned if and only if 1) restoring is
               required, and 2) restoreOnce is called with the key for
               the first time. This is a convenience function for
               restoring values only at application
               start up. Subsequent calls with the same key will
               return the default value instead of the stored one.
       \param QString key
       \param QVariant defaultValue
       \endparam
    \qmlfn restoreOnceAndRemove

    \qmlcm returns either value stored with key or defaultValue.  If
           the key is present, it calls remove() on that key
       \param QString key
       \param QVariant defaultValue
       \endparam    

    \qmlfn remove
    \qmlcm removes the given key from the store.
       \param QString key
    \endparam

    \qmlfn sync
    \qmlcm confirms that saving values has been finished. This is required in
           order for the save/restore file to be marked valid. Calling
           setValue() without sync() may cause the restoreRequired property
           to be set to "false" even when the application is launched with the
           restore command.

    \qmlfn invalidate
    \qmlcm changes the previously saved state invalid.

    \qmlfn requireSave
    \qmlcm emits saveRequired on this instance.

    \qmlfn requireSaveAll
    \qmlcm emits saveRequired on all SaveRestoreState instances.

  \section1 Example
   \qml
import Qt 4.7
import MeeGo.Components 0.1

Window {
    id: window

    toolBarTitle: "My Window"

    SaveRestoreState {
	id: myState
	onSaveRequired: {
	    setValue("square.width", square.width)
	    sync()
	}
    }

    Rectangle {
	id: square
	width: myState.restoreRequired?
               myState.value("square.width") : 400
	height: 400
	color: "blue"

	MouseArea {
            anchors.fill: parent
            onClicked: {
		myState.invalidate()
		square.width += 50
	    }
	}
    }
}
   \endqml
*/

#ifndef SAVERESTORESTATE_H
#define SAVERESTORESTATE_H

#include <QObject>
#include <QVariant>
#include <QString>
#include <QStringList>
#include <qdeclarative.h>

class QSettings;
class SaveRestoreStatePrivate;

class SaveRestoreState : public QObject
{
    Q_OBJECT;

    Q_PROPERTY(bool restoreRequired READ restoreRequired NOTIFY restoreRequiredChanged);
    Q_PROPERTY(bool alwaysValid READ alwaysValid WRITE setAlwaysValid);

public:
    static const long MinimizeToSaveInterval = 500; // milliseconds // FIXME - this does not belong into this class

    SaveRestoreState();
    ~SaveRestoreState();

    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE QStringList allKeys() const;
    Q_INVOKABLE void sync();

    Q_INVOKABLE QVariant restoreOnce(const QString &key, const QVariant &defaultValue);
    Q_INVOKABLE QVariant restoreOnceAndRemove(const QString &key, const QVariant &defaultValue);

    Q_INVOKABLE void remove(const QString &key);

    Q_INVOKABLE void setAlwaysValid(bool);
    Q_INVOKABLE bool alwaysValid();
    Q_INVOKABLE void invalidate();

    bool restoreRequired() const;

public slots:
    void requireSave();
    void requireSaveAll();

signals:
    void saveRequired();
    void restoreRequiredChanged();

private:
    static SaveRestoreStatePrivate *d;
};

QML_DECLARE_TYPE(SaveRestoreState)

#endif
