TEMPLATE = lib
TARGET = $$qtLibraryTarget(meegosaverestore)
QT += core
CONFIG += link_pkgconfig

SOURCES += saverestorestate.cpp
HEADERS += saverestorestate.h

target.path += $$[QT_INSTALL_LIBS]

OBJECTS_DIR = .obj
MOC_DIR = .moc

INSTALL_HEADERS += saverestorestate.h
headers.files = $$INSTALL_HEADERS
headers.path = $$INSTALL_ROOT/usr/include

CONFIG += create_pc create_prl
QMAKE_PKGCONFIG_DESCRIPTION = MeeGo SaveRestore
QMAKE_PKGCONFIG_INCDIR = $$headers.path
QMAKE_PKGCONFIG_DESTDIR = pkgconfig

INSTALLS += target \
            headers

EXTRA_CLEAN += $${OBJECTS_DIR}/* $${MOC_DIR}/*
