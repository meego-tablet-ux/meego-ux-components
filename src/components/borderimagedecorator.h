#ifndef BORDERIMAGEDECORATOR_H
#define BORDERIMAGEDECORATOR_H

#include <QObject>
#include <QUrl>
#include <QString>
#include <QVariant>
#include <QDeclarativeItem>

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
    Q_PROPERTY( QUrl source READ source WRITE setSource NOTIFY sourceChanged)

public:

    explicit BorderImageDecorator(QDeclarativeItem *parent = 0);
    virtual ~BorderImageDecorator();

    void setSource( const QUrl source );
    QUrl source() const;

    QDeclarativeItem *object() const;
    void setObject(QDeclarativeItem *);

    void componentComplete();

signals:
    void sourceChanged();
    void targetChanged();

private:    
    QDeclarativeItem* pTarget;
    ImageProviderCache *providerInstance;
    QUrl m_source;

    int borderTop;
    int borderBottom;
    int borderLeft;
    int borderRight;
};

QML_DECLARE_TYPE(BorderImageDecorator);

#endif// BORDERIMAGEDECORATOR_H

