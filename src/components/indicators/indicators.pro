TEMPLATE = lib

TARGETPATH = MeeGo/Ux/Components/Indicators

TARGET = meego-ux-components-indicators

QT += declarative \
        dbus

CONFIG += plugin \
        link_pkgconfig

PKGCONFIG += contextsubscriber-1.0 \
        libpulse \
        libpulse-mainloop-glib \
        mlite

SOURCES += batteryindicator.cpp \
        bluetoothindicator.cpp \
        localtime.cpp \
        musicindicator.cpp \
        musicserviceproxy.cpp \
        networkindicator.cpp \
        notificationindicator.cpp \
        plugin.cpp \
        volumecontrol.cpp

HEADERS += batteryindicator.h \
        bluetoothindicator.h \
        localtime.h \
        musicindicator.h \
        musicserviceproxy.h \
        networkindicator.h \
        notificationindicator.h \
        plugin.h \
        volumecontrol.h

QML_FILES = qmldir \
        StatusBar.qml

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH
target.depends += link

link.commands += mkdir -p ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/ && 
link.commands += ln -fs ../Ux/Components/Indicators/lib$${TARGET}.so ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so &&
link.commands += mkdir -p ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/ && 
link.commands += ln -fs ./Indicators/lib$${TARGET}.so ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so
QMAKE_EXTRA_TARGETS += link

INSTALLS += target qmlfiles
