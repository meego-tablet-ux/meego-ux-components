/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef MEMORYINFO_H
#define MEMORYINFO_H

#include <QDataStream>

using namespace std;

/* \class MemoryINfo
   this data class handles the
 */
class MemoryInfo
{
public:

    MemoryInfo() {

        lastUpdate = 0;        
        clientCount = 0;
        cacheBegin = 0;
        cacheEnd = 0;
        cacheSize = 0;

        imageCount = 0;
        imageMaxCount = 0;
        imageTableBegin = 0;
        imageTableEnd = 0;
        imageTableSize = 0;

        pixmapCount = 0;
        pixmapMaxCount = 0;
        pixmapTableBegin = 0;
        pixmapTableEnd = 0;
        pixmapTableSize = 0;

        dataBegin = 0;
        dataEnd = 0;

    }
    ~MemoryInfo() {

    }

    inline uint incUpdate() {
        lastUpdate++;
        lastUpdate = lastUpdate % 150000;
        return lastUpdate;

    }

    inline uint calcPos( uint relativePosition )
    {
        return cacheBegin + relativePosition;
    }

    inline void saveToStream( QDataStream& dataStream )
    {
        dataStream << lastUpdate;
        dataStream << clientCount;        
        dataStream << imageCount;
        dataStream << imageMaxCount;
        dataStream << imageTableBegin;
        dataStream << imageTableEnd;
        dataStream << imageTableSize;
        dataStream << pixmapCount;
        dataStream << pixmapMaxCount;
        dataStream << pixmapTableBegin;
        dataStream << pixmapTableEnd;
        dataStream << pixmapTableSize;
        dataStream << dataBegin;
        dataStream << dataEnd;
    }
    inline void loadFromStream( QDataStream& dataStream )
    {        
        dataStream >> lastUpdate;
        dataStream >> clientCount;        
        dataStream >> imageCount;
        dataStream >> imageMaxCount;
        dataStream >> imageTableBegin;
        dataStream >> imageTableEnd;
        dataStream >> imageTableSize;
        dataStream >> pixmapCount;
        dataStream >> pixmapMaxCount;
        dataStream >> pixmapTableBegin;
        dataStream >> pixmapTableEnd;
        dataStream >> pixmapTableSize;
        dataStream >> dataBegin;
        dataStream >> dataEnd;
    }

    uint lastUpdate;
    uint clientCount;
    uint cacheBegin;
    uint cacheEnd;
    uint cacheSize;
    uint imageCount;
    uint imageMaxCount;
    uint imageTableBegin;
    uint imageTableEnd;
    uint imageTableSize;
    uint pixmapCount;
    uint pixmapMaxCount;
    uint pixmapTableBegin;
    uint pixmapTableEnd;
    uint pixmapTableSize;
    uint dataBegin;
    uint dataEnd;
};
#endif // MEMORYINFO_H
