#include "scene.h"

Scene::Scene(QObject *parent) :
    QObject(parent),
    m_orientation( landscape ),
    m_orientationLock( noLock ),
    m_lockCurrentOrientation( false )
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
    } else {
        str = QString::fromLatin1("invertedLandscape");
    }
    return str;
}

void Scene::setOrientation( Orientation orientation )
{
    m_realOrientation = orientation;

    if( noLock == m_orientationLock ) {

        m_orientation = orientation;
        emit onOrientationChanged();

    } else if ( lockLandscape == m_orientationLock ) {

        if( landscape == orientation) {
            m_orientation = orientation;
            emit onOrientationChanged();
        }

    } else if ( lockPortrait == m_orientationLock ) {

        if( portrait == orientation) {
            m_orientation = orientation;
            emit onOrientationChanged();
        }

    } else if ( lockInvertedLandscape == m_orientationLock ) {

        if( invertedLandscape == orientation) {
            m_orientation = orientation;
            emit onOrientationChanged();
        }

    } else if ( lockInvertedPortrait == m_orientationLock ) {

        if( invertedPortrait == orientation) {
            m_orientation = orientation;
            emit onOrientationChanged();
        }

    } else if ( lockAllLandscape == m_orientationLock ) {

        if( landscape == orientation || invertedLandscape == orientation ) {
            m_orientation = orientation;
            emit onOrientationChanged();
        }

    } else if ( lockAllPortrait == m_orientationLock ) {

        if(  portrait == orientation || invertedPortrait == orientation ) {
            m_orientation = orientation;
            emit onOrientationChanged();
        }
    }
}
Scene::OrientationLock Scene::orientationLock() const
{
    return m_orientationLock;
}
void Scene::setOrientationLock( OrientationLock orientationLock )
{
    if( m_orientationLock != orientationLock) {

        m_orientationLock = orientationLock;
        emit onOrientationLockChanged();

        if( noLock == m_orientationLock ) {

            if( m_orientation != m_realOrientation ) {
                m_orientation = m_realOrientation;
                emit onOrientationChanged();
            }
        } else if( lockLandscape == m_orientationLock ) {

            if( m_orientation != landscape ) {
                m_orientation = landscape;
                emit onOrientationChanged();
            }

        } else if( lockPortrait == m_orientationLock ) {

            if( m_orientation != portrait ) {
                m_orientation = portrait;
                emit onOrientationChanged();
            }

        } else if( lockInvertedLandscape == m_orientationLock ) {

            if( m_orientation != invertedLandscape ) {
                m_orientation = invertedLandscape;
                emit onOrientationChanged();
            }

        } else if( lockInvertedPortrait == m_orientationLock ) {

            if( m_orientation != invertedPortrait ) {
                m_orientation = invertedPortrait;
                emit onOrientationChanged();
            }

        } else if( lockAllLandscape == m_orientationLock ) {

            if( m_orientation != landscape && m_orientation != invertedLandscape ) {
                m_orientation = landscape;
                emit onOrientationChanged();
            }

        } else if( lockAllPortrait == m_orientationLock ) {

            if( m_orientation != portrait && m_orientation != invertedPortrait ) {
                m_orientation = portrait;
                emit onOrientationChanged();
            }
        }
    }
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
    if( m_orientation == portrait || m_orientation == invertedPortrait )
        return false;
    return true;
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
                emit onOrientationChanged();
            }
        }
        emit onOrientationLockChanged();
    }
}


