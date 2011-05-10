TEMPLATE = lib

TARGETPATH = MeeGo/Ux/Models

TARGET = meego-ux-models

QT += declarative \
        dbus

CONFIG += plugin \
        link_pkgconfig

PKGCONFIG += libexif

SOURCES += devicemodel.cpp  \
        imageextension.cpp \
        plugin.cpp \
        udisk_interface.cpp

HEADERS += devicemodel.h  \
        imageextension.h \
        plugin.h \
        udisk_interface.h

QML_FILES = qmldir

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += target qmlfiles
