QT       += gui

TARGET = imageprovidercachetool
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

MOC_DIR = .moc
OBJECTS_DIR = .obj
QMAKE_CLEAN += $$MOC_DIR/* $$OBJECTS_DIR/*

QMAKE_INCDIR += ../../src/kernel

SOURCES += main.cpp \
           imageprovidercachectrl.cpp \
           ../../src/kernel/imageprovidercache.cpp

HEADERS += imageprovidercachectrl.h \
           ../../src/kernel/imageprovidercache.h \
           ../../src/kernel/memoryinfo.h \
           ../../src/kernel/imagereference.h

target.path += $$INSTALL_ROOT/usr/bin
INSTALLS += target
