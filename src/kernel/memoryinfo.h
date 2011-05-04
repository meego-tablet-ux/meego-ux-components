#ifndef MEMORYINFO_H
#define MEMORYINFO_H

#include <QDataStream>

using namespace std;

class MemoryInfo
{
public:
    MemoryInfo() {
        lastUpdate = 0;
        clients = 0;
        cacheSize = 0;
        tableSize = 0;
        imageCount = 0;
        imageMaxCount = 0;
        tableBegin = 0;
        tableEnd = 0;
        dataBegin = 0;
        dataEnd = 0;
    }
    ~MemoryInfo() {

    }

    inline void saveToStream( QDataStream& dataStream )
    {
        dataStream << lastUpdate;
        dataStream << clients;
        dataStream << cacheSize;
        dataStream << imageCount;
        dataStream << imageMaxCount;
        dataStream << tableBegin;
        dataStream << tableEnd;
        dataStream << tableSize;
        dataStream << dataBegin;
        dataStream << dataEnd;
        dataStream << cacheEnd;
    }
    inline void loadFromStream( QDataStream& dataStream )
    {
        dataStream >> lastUpdate;
        dataStream >> clients;
        dataStream >> cacheSize;
        dataStream >> imageCount;
        dataStream >> imageMaxCount;
        dataStream >> tableBegin;
        dataStream >> tableEnd;
        dataStream >> tableSize;
        dataStream >> dataBegin;
        dataStream >> dataEnd;
        dataStream >> cacheEnd;
    }

    uint lastUpdate;
    uint clients;
    uint cacheSize;
    uint cacheEnd;
    uint imageCount;
    uint imageMaxCount;
    uint tableBegin;
    uint tableEnd;
    uint tableSize;
    uint dataBegin;
    uint dataEnd;

};

/*
QDataStream& operator<<( QDataStream& dataStream, const MemoryInfo& memoryInfo )
{
    dataStream << memoryInfo.lastUpdate;
    dataStream << memoryInfo.cacheSize;
    dataStream << memoryInfo.imageCount;
    dataStream << memoryInfo.imageMaxCount;
    dataStream << memoryInfo.tableBegin;
    dataStream << memoryInfo.tableEnd;
    dataStream << memoryInfo.dataBegin;
    dataStream << memoryInfo.dataEnd;

    return dataStream;
}
QDataStream& operator>>( QDataStream& dataStream, MemoryInfo& memoryInfo )
{
    dataStream >> memoryInfo.lastUpdate;
    dataStream >> memoryInfo.cacheSize;
    dataStream >> memoryInfo.imageCount;
    dataStream >> memoryInfo.imageMaxCount;
    dataStream >> memoryInfo.tableBegin;
    dataStream >> memoryInfo.tableEnd;
    dataStream >> memoryInfo.dataBegin;
    dataStream >> memoryInfo.dataEnd;

    return dataStream;
}
 */
#endif // MEMORYINFO_H
