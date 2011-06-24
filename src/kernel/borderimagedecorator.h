#ifndef BORDERIMAGEDECORATOR_H
#define BORDERIMAGEDECORATOR_H

#include <QObject>
#include <QUrl>
#include <QString>
#include <QVariant>
#include <QDeclarativeItem>
#include <QtDeclarative>

class ImageProviderCache;

/*! \class BorderImageDecorator
 this declarative class helps to transport the border values from the sci file, loaded by the
 imageProviderCache into the BorderImage. This is a workaround for the sci bug in BorderImage,
 which can not load sci files from imageproviders currently.

 By default the target is the parent item. The shortes way to use the decorator is this way:

 \qml
 #include MeeGo.Components 0.1

 BorderImage {

    id: image
    source: "image:/themedImage/myImageString"
    BorderImageDecorator {}

 }
 \endqml

 In order to have a more readable API, the target and the source can also be set in the decorator:

 \qml
 #include MeeGo.Components 0.1

 BorderImage {

    id: image
    source: "image:/themedImage/myImageString"

    BorderImageDecorator {
        id: imageDecorator
        target: image
        source: "image:/themedImage/myImageString"
    }

 }
 \endqml

*/
class BorderImageDecorator : public QDeclarativeItem
{
    Q_OBJECT
    /*! target: parentItem by Default */
    Q_PROPERTY( QDeclarativeItem *target READ object WRITE setObject NOTIFY targetChanged )

    Q_PROPERTY( QUrl source READ source WRITE setSource NOTIFY sourceChanged )
    /*! \qmlproperty defaultSource allows to enter a default source if source can not be found */
    Q_PROPERTY( QUrl defaultSource READ defaultSource WRITE setDefaultSource NOTIFY defaultSourceChanged )
    /*! \qmlproperty isValidSource: */
    Q_PROPERTY( bool isValidSource READ isValidSource NOTIFY isValidSourceChanged )

    /*! \qmlproperty borderTop: topBorder pixel of the BorderImage */
    Q_PROPERTY( int borderTop READ borderTop NOTIFY borderChanged);
    /*! \qmlproperty borderBottom: topBorder pixel of the BorderImage */
    Q_PROPERTY( int borderBottom READ borderBottom NOTIFY borderChanged);
    /*! \qmlproperty borderLeft: topBorder pixel of the BorderImage */
    Q_PROPERTY( int borderLeft READ borderLeft NOTIFY borderChanged);
    /*! \qmlproperty borderRight: topBorder pixel of the BorderImage */
    Q_PROPERTY( int borderRight READ borderRight NOTIFY borderChanged);

public:

    explicit BorderImageDecorator(QDeclarativeItem *parent = 0);
    virtual ~BorderImageDecorator();

    QDeclarativeItem *object() const;
    void setObject(QDeclarativeItem *);

    void setSource( const QUrl& defaultSource );
    QUrl source() const;

    void setDefaultSource( const QUrl& defaultSource );
    QUrl defaultSource() const;

    bool isValidSource() const;

    int borderTop() const;
    int borderBottom() const;
    int borderRight() const;
    int borderLeft() const;

signals:
    void borderChanged();
    void targetChanged();
    void defaultSourceChanged();
    void sourceChanged();
    void isValidSourceChanged();

private:

    void checkSource();
    void getBorder();

    QDeclarativeItem* pTarget;
    ImageProviderCache *providerInstance;    
    QUrl m_source;
    QUrl m_defaultSource;

    int m_borderTop;
    int m_borderBottom;
    int m_borderLeft;
    int m_borderRight;
};

QML_DECLARE_TYPE(BorderImageDecorator);

#endif// BORDERIMAGEDECORATOR_H

