/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

/*! 
  \qmlclass SaveRestoreState
  \title SaveRestoreState
  \section1 SaveRestoreState
  SaveRestoreState provides tools for saving and restoring
  states of applications.
  
  SaveRestoreState emits saveRequired when the application should save
  its state. State is saved using setValue(key, value) and by finally
  calling sync().

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
    \qmlcm returns the value stored with the key.
           If no value has been stored with the key, returns the
           default value.
       \param QString key
       \param QVariant defaultValue (optional)
       \qmlcm if not given, defaultValue defaults to QVariant().\endparam

    \qmlfn sync
    \qmlcm confirms that saving values has been finished.

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
    Q_INVOKABLE void sync();

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
