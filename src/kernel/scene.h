/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef SCENE_H
#define SCENE_H

#include <QObject>

class Scene : public QObject
{
    Q_OBJECT

    Q_ENUMS( Orientation OrientationLock );

    Q_PROPERTY( QString orientationString READ orientationString NOTIFY orientationChanged )
    Q_PROPERTY( Scene::Orientation orientation READ orientation WRITE setOrientation NOTIFY orientationChanged )
    Q_PROPERTY( Scene::OrientationLock orientationLock READ orientationLock WRITE setOrientationLock NOTIFY orientationLockChanged )
    Q_PROPERTY( bool orientationLocked READ orientationLocked )
    Q_PROPERTY( bool lockCurrentOrientation READ orientationLocked WRITE lockCurrentOrientation )

    Q_PROPERTY( bool inhibitScreenSaver READ inhibitScreenSaver WRITE setInhibitScreenSaver NOTIFY inhibitScreenSaverChanged )
    Q_PROPERTY( bool isActiveScene READ isActiveScene WRITE setActiveScene NOTIFY activeSceneChanged )

    Q_PROPERTY( int winId READ winId WRITE setWinId )
    Q_PROPERTY( int activeWinId READ activeWinId WRITE setActiveWinId )

    Q_PROPERTY( bool inLandscape READ inLandscape NOTIFY orientationChanged )
    Q_PROPERTY( bool inPortrait READ inPortrait NOTIFY orientationChanged )
    Q_PROPERTY( bool inInvertedLandscape READ inInvertedLandscape NOTIFY orientationChanged )
    Q_PROPERTY( bool inInvertedPortrait READ inInvertedPortrait NOTIFY orientationChanged )

public:

    enum Orientation {
        landscape = 1,
        portrait = 2,
        invertedLandscape = 3,
        invertedPortrait = 0
    };
    enum OrientationLock {
        noLock = 0,
        lockLandscape = 1,
        lockPortrait = 2,
        lockInvertedLandscape = 3,
        lockInvertedPortrait = 4,
        lockAllLandscape = 5,
        lockAllPortrait = 6
    };

    explicit Scene(QObject *parent = 0);

    QString orientationString() const;

    Scene::Orientation orientation() const;
    void setOrientation( Orientation orientation );

    Scene::OrientationLock orientationLock() const;
    void setOrientationLock( OrientationLock orientationLock );
    bool orientationLocked() const;
    void lockCurrentOrientation( bool lock );

    bool inLandscape() const;
    bool inPortrait() const;
    bool inInvertedLandscape() const;
    bool inInvertedPortrait() const;

    bool isActiveScene() const;
    void setActiveScene( bool active ) { m_bSceneActive = active; }

    int winId() const;
    void setWinId( int winId );

    int activeWinId() const;
    void setActiveWinId( int activeWinId );

    bool inhibitScreenSaver() const;
    void setInhibitScreenSaver( bool inhibit );

signals:
    void orientationChanged();
    void orientationLockChanged();
    void activeSceneChanged();
    void inhibitScreenSaverChanged();
    void disableSceneChanged();

private:
   Orientation m_orientation;
   Orientation m_realOrientation;
   OrientationLock m_orientationLock;

   bool m_lockCurrentOrientation;
   bool m_bSceneActive;
   bool m_bInhibitScreenSaver;
   bool m_bActiveInhibitScreenSaver;
   int m_activeWinId;
   int m_myWinId;

};

#endif // SCREEN_H
