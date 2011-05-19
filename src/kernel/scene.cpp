/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include "scene.h"
#include <QDebug>

Scene::Scene(QObject *parent) :
    QObject(parent),
    m_orientation( landscape ),
    m_orientationLock( noLock ),
    m_lockCurrentOrientation( false ),
    m_bSceneActive( true ),
    m_activeWinId( 0 ),
    m_myWinId( 0 )
{
}
Scene::Orientation Scene::orientation() const
{
    return m_orientation;
}

QString Scene::orientationString() const
{
    QString str;

    if( landscape == m_orientation ) {
        str = QString::fromLatin1("landscape");
    } else if( portrait == m_orientation ) {
        str = QString::fromLatin1("portrait");
    } else if( invertedPortrait == m_orientation ) {
        str = QString::fromLatin1("invertedPortrait");
    } else if( invertedLandscape == m_orientation ) {
        str = QString::fromLatin1("invertedLandscape");
    } else {
        str = QString::fromLatin1("landscape");
    }

    return str;
}

void Scene::setOrientation( Orientation orientation )
{

    m_realOrientation = orientation;
  
    if( m_bSceneActive ) {

        if( noLock == m_orientationLock ) {

            m_orientation = orientation;
            emit orientationChanged();

        } else if ( lockLandscape == m_orientationLock ) {

            if( landscape == orientation) {
                m_orientation = orientation;
                emit orientationChanged();             
            }

        } else if ( lockPortrait == m_orientationLock ) {

            if( portrait == orientation) {
                m_orientation = orientation;
                emit orientationChanged();
            }

        } else if ( lockInvertedLandscape == m_orientationLock ) {

            if( invertedLandscape == orientation) {
                m_orientation = orientation;
                emit orientationChanged();
            }

        } else if ( lockInvertedPortrait == m_orientationLock ) {

            if( invertedPortrait == orientation) {
                m_orientation = orientation;
                emit orientationChanged();
            }

        } else if ( lockAllLandscape == m_orientationLock ) {

            if( landscape == orientation || invertedLandscape == orientation ) {
                m_orientation = orientation;                
                emit orientationChanged();
            }

        } else if ( lockAllPortrait == m_orientationLock ) {

            if(  portrait == orientation || invertedPortrait == orientation ) {
                m_orientation = orientation;                
                emit orientationChanged();
            }
        }
    }

    emit orientationChanged();
}
Scene::OrientationLock Scene::orientationLock() const
{
    return m_orientationLock;
}
void Scene::setOrientationLock( OrientationLock orientationLock )
{
    if( m_orientationLock != orientationLock) {

        m_orientationLock = orientationLock;

        if( noLock == m_orientationLock ) {

            if( m_orientation != m_realOrientation ) {
                m_orientation = m_realOrientation;
                emit orientationChanged();
            }
        } else if( lockLandscape == m_orientationLock ) {

            if( m_orientation != landscape ) {
                m_orientation = landscape;
                emit orientationChanged();
            }

        } else if( lockPortrait == m_orientationLock ) {

            if( m_orientation != portrait ) {
                m_orientation = portrait;
                emit orientationChanged();
            }

        } else if( lockInvertedLandscape == m_orientationLock ) {

            if( m_orientation != invertedLandscape ) {
                m_orientation = invertedLandscape;
                emit orientationChanged();
            }

        } else if( lockInvertedPortrait == m_orientationLock ) {

            if( m_orientation != invertedPortrait ) {
                m_orientation = invertedPortrait;
                emit orientationChanged();
            }

        } else if( lockAllLandscape == m_orientationLock ) {

            if( m_orientation != landscape && m_orientation != invertedLandscape ) {
                m_orientation = landscape;
                emit orientationChanged();
            }

        } else if( lockAllPortrait == m_orientationLock ) {

            if( m_orientation != portrait && m_orientation != invertedPortrait ) {
                m_orientation = portrait;
                emit orientationChanged();
            }
        }
        emit orientationChanged();
    }

    emit orientationLockChanged();

}

bool Scene::orientationLocked() const
{
    if( m_orientationLock != noLock )
        return true;
    return false;
}

bool Scene::inPortrait() const
{
    if( m_orientation == portrait || m_orientation == invertedPortrait )
        return true;
    return false;
}
bool Scene::inLandscape() const
{
    if( m_orientation == landscape || m_orientation == invertedLandscape )
        return false;
    return true;
}
bool Scene::inInvertedLandscape() const
{
    if( m_orientation == landscape )
        return true;
    return false;
}
bool Scene::inInvertedPortrait() const
{
    if( m_orientation == portrait )
        return true;
    return false;
}

void Scene::lockCurrentOrientation( bool lock )
{
    if( m_lockCurrentOrientation != lock ) {
        m_lockCurrentOrientation = lock;
        if( m_lockCurrentOrientation ) {
            if( m_orientation == landscape ) {
                m_orientationLock = lockLandscape;
            } else if ( m_orientation == invertedLandscape ) {
                m_orientationLock = lockInvertedLandscape;
            } else if ( m_orientation == portrait ) {
                m_orientationLock = lockPortrait;
            } else {
                m_orientationLock = lockInvertedPortrait;
            }
        } else {
            m_orientationLock = noLock;
            if( m_realOrientation != m_orientation) {
                m_orientation = m_realOrientation;
                emit orientationChanged();
            }
        }
        emit orientationLockChanged();
    }
}

bool Scene::isActiveScene() const
{
    return m_bSceneActive;
}

int Scene::winId() const
{
    return m_myWinId;
}

void Scene::setWinId( int winId )
{
    if( m_myWinId == 0 ) {

        m_myWinId = winId;
        if( m_myWinId == m_activeWinId ) {

            m_bSceneActive = true;

        } else {

            m_bSceneActive = false;

        }
        emit activeSceneChanged();
    }
}

int Scene::activeWinId() const
{
    return m_activeWinId;
}

void Scene::setActiveWinId( int activeWinId )
{
    if( activeWinId != m_activeWinId) {

        m_activeWinId = activeWinId;

        if( m_myWinId != m_activeWinId && m_bSceneActive ) {

            m_bSceneActive = false;
            emit activeSceneChanged();

            if( m_bInhibitScreenSaver == false ) {

                m_bActiveInhibitScreenSaver = false;
                m_bInhibitScreenSaver = true;
                emit inhibitScreenSaverChanged();

            } else {

                m_bActiveInhibitScreenSaver = true;
                emit inhibitScreenSaverChanged();

            }

        } else if ( m_myWinId == m_activeWinId && !m_bSceneActive ) {

            //activate Window:

            m_bSceneActive = true;
            emit activeSceneChanged();

            if( !m_bActiveInhibitScreenSaver ) {

                m_bInhibitScreenSaver = m_bActiveInhibitScreenSaver;
                emit inhibitScreenSaverChanged();

            }
            setOrientation( m_realOrientation );
            emit orientationLockChanged();

            emit orientationLockChanged();
        }
    }
}

bool Scene::inhibitScreenSaver() const
{
    return m_bInhibitScreenSaver;
}

void Scene::setInhibitScreenSaver( bool inhibit )
{
    if( m_bInhibitScreenSaver != inhibit )
    {
        if( m_bSceneActive ) {

            m_bInhibitScreenSaver = inhibit;
            emit inhibitScreenSaverChanged();

        } else {

            m_bActiveInhibitScreenSaver = inhibit;

        }
    }
}
