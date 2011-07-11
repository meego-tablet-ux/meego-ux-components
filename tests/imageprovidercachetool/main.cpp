#include <iostream>
#include <QtCore/QCoreApplication>
#include <QStringList>

#include "../../src/kernel/imageprovidercachectrl.h"

void printHelp()
{
    std::cout << "ImageProviderCacheTool: " << std::endl;
    std::cout << "-mem --mem -m %name%: name of the sharedMemory, by default 'ImageProviderCache/meego/ux/theme' " << std::endl;
    std::cout << "-clear --clear -c: clear shared memory:" << std::endl;    
    std::cout << "-reload --reload -r: reload shared memory" << std::endl;
    //std::cout << "-save --save -s %filename%: save shared memory payload" << std::endl;
    //std::cout << "-load --load -l %filename%: load shared memory payload" << std::endl;
    std::cout << "-bulk --bulk -b: bulk shared memory" << std::endl;
    std::cout << "example: " << std::endl;
    std::cout << "ImageProviderCacheTool -c ( -mem ImageProviderCache/meego/ux/theme ) " << std::endl;
    std::cout.flush();
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    int ret = -1;

    QString filename = QString::fromLatin1( "filename" );
    QString sharedMemoryName = QString::fromLatin1( "ImageProviderCache/meego/ux/theme" );
    QStringList args = QCoreApplication::arguments();

    if( args.contains( "-m", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "-m" ) + 1 ;
        sharedMemoryName = args.at( count );

    } else if( args.contains( "-mem", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "-mem" ) + 1;
        sharedMemoryName = args.at( count );

    } else if( args.contains( "--mem", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "--mem" ) + 1;
        sharedMemoryName = args.at( count );

    }

    if( args.contains( "-s", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "-s" ) + 1 ;
        filename = args.at( count );

    } else if( args.contains( "-save", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "-save" ) + 1;
        filename = args.at( count );

    } else if( args.contains( "--save", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "--save" ) + 1;
        filename = args.at( count );

    } else if( args.contains( "-l", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "-l" ) + 1 ;
        filename = args.at( count );

    } else if( args.contains( "-load", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "-load" ) + 1;
        filename = args.at( count );

    } else if( args.contains( "--load", Qt::CaseSensitive ) ) {

        int count = args.indexOf( "--load" ) + 1;
        filename = args.at( count );

    }

    if( args.count() == 1 ||
        args.contains( "--help", Qt::CaseInsensitive ) ||
        args.contains( "-help", Qt::CaseInsensitive ) ||
        args.contains( "-h", Qt::CaseInsensitive ) ) {

        printHelp();
        ret = 1;

    } else if( args.contains( "--clear", Qt::CaseInsensitive ) ||
               args.contains( "-clear", Qt::CaseInsensitive ) ||
               args.contains( "-c", Qt::CaseInsensitive ) ) {

        ImageProviderCacheCtrl ctrl( sharedMemoryName );

        std::cout << "clear sharedMemory: " << sharedMemoryName.toStdString() << std::endl;

        ImageProviderCacheCtrl::Result result = ctrl.clearCache();

        if( ImageProviderCacheCtrl::None == result ) {
            std::cout << "error: clear sharedMemory - no operation" << std::endl;
        } else if( ImageProviderCacheCtrl::MemoryNotFound == result ) {
            std::cout << "error: clear sharedMemory - shared memory not found" << std::endl;
        } else if( ImageProviderCacheCtrl::CacheCleared == result) {
            std::cout << "clear sharedMemory - shared memory cleared" << std::endl;
            ret = 1;
        } else if( ImageProviderCacheCtrl::UndefinedError == result ) {
            std::cout << "error: clear sharedMemory - undefined error" << std::endl;
        }

    } else if( args.contains( "--reload", Qt::CaseInsensitive ) ||
               args.contains( "-reload", Qt::CaseInsensitive ) ||
               args.contains( "-r", Qt::CaseInsensitive ) ) {

        ImageProviderCacheCtrl ctrl( sharedMemoryName );

        std::cout << "reload sharedMemory: " << sharedMemoryName.toStdString() << std::endl;
        // std::cout << ctrl.smallBulkCache() << endl;

        ImageProviderCacheCtrl::Result result = ctrl.reloadCache();

        if( ImageProviderCacheCtrl::None == result ) {
            std::cout << "error: reload sharedMemory - no operation" << std::endl;
        } else if( ImageProviderCacheCtrl::MemoryNotFound == result ) {
            std::cout << "error: reload sharedMemory - shared memory not found" << std::endl;
        } else if( ImageProviderCacheCtrl::CacheCleared == result) {
            std::cout << "reload sharedMemory - shared memory reloaded" << std::endl;
            ret = 1;
        } else if( ImageProviderCacheCtrl::UndefinedError == result ) {
            std::cout << "error: reload sharedMemory - undefined error" << std::endl;
        }

    } else if( args.contains( "--bulk", Qt::CaseInsensitive ) ||
               args.contains( "-bulk", Qt::CaseInsensitive ) ||
               args.contains( "-b", Qt::CaseInsensitive ) ) {

        std::cout << "bulk sharedMemory: " << sharedMemoryName.toStdString() << std::endl;

        ImageProviderCacheCtrl ctrl( sharedMemoryName );

        QStringList list = ctrl.bulkCache();
        foreach( QString line, list ) {
            std::cout << line.toStdString() << std::endl;
        }
        ret = 1;

    }  else if( args.contains( "--save", Qt::CaseInsensitive ) ||
               args.contains( "-save", Qt::CaseInsensitive ) ||
               args.contains( "-s", Qt::CaseInsensitive ) ) {

        std::cout << "save sharedMemory: " << sharedMemoryName.toStdString() << std::endl;

        ImageProviderCacheCtrl ctrl( sharedMemoryName );
        ImageProviderCacheCtrl::Result result = ctrl.savePayload( filename );

        if( ImageProviderCacheCtrl::None == result ) {
            std::cout << "error: save sharedMemory - no operation" << std::endl;
        } else if( ImageProviderCacheCtrl::MemoryNotFound == result ) {
            std::cout << "error: save sharedMemory - shared memory not found" << std::endl;
        } else if( ImageProviderCacheCtrl::CacheSaved == result) {
            std::cout << "save sharedMemory - shared memory saved" << std::endl;
            ret = 1;
        } else if( ImageProviderCacheCtrl::UndefinedError == result ) {
            std::cout << "error: save sharedMemory - undefined error" << std::endl;
        }

    } else if( args.contains( "--load", Qt::CaseInsensitive ) ||
               args.contains( "-load", Qt::CaseInsensitive ) ||
               args.contains( "-l", Qt::CaseInsensitive ) ) {

        std::cout << "load sharedMemory: " << sharedMemoryName.toStdString() << std::endl;

        ImageProviderCacheCtrl ctrl( sharedMemoryName );
        ImageProviderCacheCtrl::Result result = ctrl.loadPayLoad( filename );

        if( ImageProviderCacheCtrl::None == result ) {
            std::cout << "error: load sharedMemory - no operation" << std::endl;
        } else if( ImageProviderCacheCtrl::MemoryNotFound == result ) {
            std::cout << "error: load sharedMemory - shared memory not found" << std::endl;
        } else if( ImageProviderCacheCtrl::CacheLoaded == result) {
            std::cout << "load sharedMemory - loaded" << std::endl;
            ret = 1;
        } else if( ImageProviderCacheCtrl::UndefinedError == result ) {
            std::cout << "error: load sharedMemory - undefined error" << std::endl;
        }
    }

    std::cout.flush();
    return ret;
}
