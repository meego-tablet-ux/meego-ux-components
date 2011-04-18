#ifndef SCENE_H
#define SCENE_H

#include <QObject>

class Scene : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString orientationString READ orientationString NOTIFY onOrientationChanged )
    Q_PROPERTY( Scene::Orientation orientation READ orientation WRITE setOrientation NOTIFY onOrientationChanged )
    Q_PROPERTY( Scene::OrientationLock orientationLock READ orientationLock WRITE setOrientationLock NOTIFY onOrientationLockChanged )
    Q_PROPERTY( bool orientationLocked READ orientationLocked )
    Q_PROPERTY( bool lockCurrentOrientation READ orientationLocked WRITE lockCurrentOrientation )
    Q_PROPERTY( bool inLandscape READ inLandscape NOTIFY onInLandscapeChanged )
    Q_PROPERTY( bool inPortrait READ inPortrait NOTIFY onInPortraitChanged )
    Q_ENUMS( Orientation );
    Q_ENUMS( OrientationLock );

public:

    enum Orientation {
        landscape = 1,
        portrait = 2,
        invertedLandscape = 3,
        invertedPortrait = 0
    };
    enum OrientationLock {
        noLock = 0,
        lockLandscape,
        lockPortrait,
        lockInvertedLandscape,
        lockInvertedPortrait,
        lockAllLandscape,
        lockAllPortrait
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



signals:
    void onOrientationChanged();
    void onOrientationLockChanged();
    void onInLandscapeChanged();
    void onInPortraitChanged();

private:
   Orientation m_orientation;
   Orientation m_realOrientation;
   OrientationLock m_orientationLock;

   bool m_lockCurrentOrientation;

};



#endif // SCREEN_H
