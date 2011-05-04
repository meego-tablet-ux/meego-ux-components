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
        if( getUrl().toString() == url.toString() &&
            width == size.width() &&
            height == size.height() )
            return true;
        return false;
    }
    inline bool equadId( ImageReference& other )
    {
        if( ::wcscmp( wurl, other.wurl ) == 0 )
            return true;
        return false;
    }
    inline bool equalId( const QString& id )
    {
        if( id == id() )
            return true;
        return false;
    }
    inline void setId( QString& id ) {
        if( id.length() < WCHARLENGTH ) {
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
    uint memoryPosition;
    uint memorySize;
};

/*

{
    size_t length = wcslen( wchar );
    dataStream.writeRawData( (char*)wchar, min( (int)length, 1024 ) );
    return dataStream;

}
QDataStream& operator>>( QDataStream& dataStream, wchar_t* wchar )
{
    wchar_t w[WCHARLENGTH];
    dataStream.readRawData( (char*)w , 1024 );
    QString::fromWCharArray( w );

    if( wchar != 0 && ::wcslen( wchar ) >= wcslen( w ) )
    wcscpy( wchar, w );

    return dataStream;
}

QDataStream& operator<<( QDataStream& dataStream, const ImageReference& imageReference )
{
    dataStream << imageReference.wurl;
    dataStream << imageReference.refCount;
    dataStream << imageReference.width;
    dataStream << imageReference.height;
    dataStream << imageReference.borderTop;
    dataStream << imageReference.borderBottom;
    dataStream << imageReference.borderLeft;
    dataStream << imageReference.borderRight;
    dataStream << imageReference.memoryPosition;
    dataStream << imageReference.memorySize;

    return dataStream;
}
QDataStream& operator>>( QDataStream& dataStream, ImageReference& imageReference )
{

    dataStream >> imageReference.wurl;
    dataStream >> imageReference.refCount;
    dataStream >> imageReference.width;
    dataStream >> imageReference.height;
    dataStream >> imageReference.borderTop;
    dataStream >> imageReference.borderBottom;
    dataStream >> imageReference.borderLeft;
    dataStream >> imageReference.borderRight;
    dataStream >> imageReference.memoryPosition;
    dataStream >> imageReference.memorySize;

    return dataStream;
}
/*/

#endif // IMAGEREFERENCE_H
