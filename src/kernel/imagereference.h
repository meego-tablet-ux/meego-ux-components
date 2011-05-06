#ifndef IMAGEREFERENCE_H
#define IMAGEREFERENCE_H

#include <QDataStream>
#include <QString>
#include <QSize>
#include <QDebug>

#ifdef WINDOWS
#define WCHARBYTE 2
#else
#define WCHARBYTE 4
#endif
#define WCHARLENGTH 512

using namespace std;

class PixmapReference
{
public:

    PixmapReference() {

        borderBottom = 0;
        borderLeft = 0;
        borderRight = 0;
        borderTop = 0;
        height = 0;
        width = 0;
        pixMapHandle = 0;
        refCount = 0;

        for( int i = 0; i < WCHARLENGTH; i++ )
            wurl[i] = '\0';

    }
    PixmapReference( const PixmapReference& other ) {
        wcscpy( wurl, other.wurl );
        refCount = other.refCount;
        width= other.width;
        height = other.height;
        borderLeft = other.borderLeft;
        borderTop = other.borderTop;
        borderRight = other.borderRight;
        borderBottom = other.borderBottom;
        pixMapHandle = other.pixMapHandle;
    }
    ~PixmapReference()
    {

    }

    inline void saveToStream( QDataStream& dataStream )
    {
        dataStream.writeRawData( (char*)wurl, WCHARLENGTH * WCHARBYTE );
        dataStream << refCount;
        dataStream << width;
        dataStream << height;
        dataStream << borderTop;
        dataStream << borderBottom;
        dataStream << borderLeft;
        dataStream << borderRight;
        dataStream << pixMapHandle;

    }
    inline void loadFromStream( QDataStream& dataStream)
    {        
        dataStream.readRawData( (char*)wurl , WCHARLENGTH * WCHARBYTE );
        dataStream >> refCount;
        dataStream >> width;
        dataStream >> height;
        dataStream >> borderTop;
        dataStream >> borderBottom;
        dataStream >> borderLeft;
        dataStream >> borderRight;
        dataStream >> pixMapHandle;
    }
    inline bool equal( PixmapReference& other )
    {
        if( wcscmp( wurl, other.wurl ) == 0 &&
            width == other.width &&
            height == other.height )
            return true;
        return false;
    }
    inline bool equal( const QString& id, const QSize& size )
    {
        QString myId = QString::fromWCharArray( wurl );
        if( ( QString::compare( id, myId ) == 0 ) &&
            width == size.width() &&
            height == size.height() )
            return true;
        return false;
    }
    inline bool equal( const QString& id )
    {
        QString myId = QString::fromWCharArray( wurl );
        if( QString::compare( id, myId ) == 0 )
            return true;
        return false;
    }
    inline void setId( const QString& id ) {
        if( id.length() < WCHARLENGTH ) {
            for( int i = 0; i < WCHARLENGTH; i++ )
                wurl[i] = '\0';
            id.toWCharArray( wurl );
        }
    }
    inline QString id() {

        if( wurl == 0 )
            return QString();

        return QString::fromWCharArray( wurl );
    }

    wchar_t wurl[WCHARLENGTH];
    uint refCount;
    int width;
    int height;
    uint borderLeft;
    uint borderTop;
    uint borderRight;
    uint borderBottom;
    quint64 pixMapHandle;
};

class ImageReference
{
public:

    ImageReference() {
        borderBottom = 0;
        borderLeft = 0;
        borderRight = 0;
        borderTop = 0;
        height = 0;
        width = 0;
        memoryPosition = 0;
        memorySize = 0;
        refCount = 0;

        for( int i = 0; i < WCHARLENGTH; i++ )
            wurl[i] = '\0';

    }
    ImageReference( const ImageReference& other ) {
        wcscpy( wurl, other.wurl );
        refCount = other.refCount;
        width= other.width;
        height = other.height;
        borderLeft = other.borderLeft;
        borderTop = other.borderTop;
        borderRight = other.borderRight;
        borderBottom = other.borderBottom;
        memoryPosition = other.memoryPosition;
        memorySize = other.memorySize;
    }
    ~ImageReference()
    {

    }

    inline void saveToStream( QDataStream& dataStream )
    {
        dataStream.writeRawData( (char*)wurl, WCHARLENGTH * WCHARBYTE );
        dataStream << refCount;
        dataStream << width;
        dataStream << height;
        dataStream << borderTop;
        dataStream << borderBottom;
        dataStream << borderLeft;
        dataStream << borderRight;
        dataStream << memoryPosition;
        dataStream << memorySize;
    }
    inline void loadFromStream( QDataStream& dataStream)
    {        
        dataStream.readRawData( (char*)wurl , WCHARLENGTH * WCHARBYTE );
        dataStream >> refCount;
        dataStream >> width;
        dataStream >> height;
        dataStream >> borderTop;
        dataStream >> borderBottom;
        dataStream >> borderLeft;
        dataStream >> borderRight;
        dataStream >> memoryPosition;
        dataStream >> memorySize;
    }

    inline bool equal( ImageReference& other )
    {
        if( wcscmp( wurl, other.wurl ) == 0 &&
            width == other.width &&
            height == other.height )
            return true;
        return false;
    }
    inline bool equal( const QString& id, const QSize& size )
    {
        QString myId = QString::fromWCharArray( wurl );
        if( ( QString::compare( id, myId ) == 0 ) &&
            width == size.width() &&
            height == size.height() ) {
            return true;
        }
        return false;
    }    
    inline bool equal( const QString& id )
    {
        QString myId = QString::fromWCharArray( wurl );
        if( QString::compare( id, myId ) == 0 )
            return true;
        return false;
    }

    void setId( const QString& id ) {

        if( id.length() < WCHARLENGTH ) {            
            for( int i = 0; i < WCHARLENGTH; i++ )
                wurl[i] = '\0';
            id.toWCharArray( wurl );
        }
    }
    QString id() {

        if( wurl == 0 )
            return QString();

        return QString::fromWCharArray( wurl );
    }

    size_t sizeOfStream;

    wchar_t wurl[WCHARLENGTH];
    uint refCount;
    int width;
    int height;
    uint borderLeft;
    uint borderTop;
    uint borderRight;
    uint borderBottom;
    uint memoryPosition;
    uint memorySize;
};

#endif // IMAGEREFERENCE_H
