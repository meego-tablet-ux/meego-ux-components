/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

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

/*! \class PixmapReference
 *  this data class is used to store the relevant pixmap data into the shared memory
 */
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
        memoryPosition = 0;
        memorySize = 0;
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
        memoryPosition = other.memoryPosition;
        memorySize = other.memorySize;
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
        dataStream >> pixMapHandle;
        dataStream >> memoryPosition;
        dataStream >> memorySize;
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
    uint memoryPosition;
    uint memorySize;
    quint64 pixMapHandle;
};

/*! \class ImageReference
 *  this data class is used to store the relevant image data into the shared memory
 *  the reference to the image is done by casting into the memory.
 */
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
