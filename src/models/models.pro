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
target.depends += link

link.commands += mkdir -p ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/ && 
link.commands += ln -fs ../Ux/Models/lib$${TARGET}.so ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so &&
link.commands += mkdir -p ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/ && 
link.commands += ln -fs ../Models/lib$${TARGET}.so ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so
QMAKE_EXTRA_TARGETS += link

INSTALLS += target qmlfiles
