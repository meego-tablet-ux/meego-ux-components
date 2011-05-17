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
    Q_PROPERTY( int borderTop READ borderTop NOTIFY borderChanged);
    Q_PROPERTY( int borderBottom READ borderBottom NOTIFY borderChanged);
    Q_PROPERTY( int borderLeft READ borderLeft NOTIFY borderChanged);
    Q_PROPERTY( int borderRight READ borderRight NOTIFY borderChanged);

public:

    explicit BorderImageDecorator(QDeclarativeItem *parent = 0);
    virtual ~BorderImageDecorator();

    QDeclarativeItem *object() const;
    void setObject(QDeclarativeItem *);

    void componentComplete();

    int borderTop() const;
    int borderBottom() const;
    int borderRight() const;
    int borderLeft() const;

signals:
    void borderChanged();
    void targetChanged();

public slots:
    void onSourceChanged();

private:

    void getBorder();

    QDeclarativeItem* pTarget;
    ImageProviderCache *providerInstance;
    QUrl m_source;

    int m_borderTop;
    int m_borderBottom;
    int m_borderLeft;
    int m_borderRight;
};

QML_DECLARE_TYPE(BorderImageDecorator);

#endif// BORDERIMAGEDECORATOR_H
