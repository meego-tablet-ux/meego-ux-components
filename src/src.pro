TEMPLATE = lib
MOBILITY = publishsubscribe
TARGET = meego-ux-components

include(kernel/kernel.pri)
include(models/models.pri)
include(components/ux/ux.pri)
include(units/units.pri)

QT += declarative \
      network \
      dbus \
      sql

CONFIG += qt \
    plugin \
    mobility \
    mlite \
    dbus \
    link_pkgconfig \

PKGCONFIG += gconf-2.0 \
    qmfmessageserver \
    qmfclient \
    libpulse \
    libpulse-mainloop-glib \
    libexif \
    libkcalcoren \
    contentaction-0.1 \
    mlite \
    xdamage \
    QtPublishSubscribe \
    contextsubscriber-1.0

TARGET = $$qtLibraryTarget($$TARGET)
#DESTDIR = $$[QT_INSTALL_IMPORTS]/MeeGo/Components
OBJECTS_DIR = .obj
MOC_DIR = .moc

QTDIR_build:DESTDIR = $$QT_BUILD_TREE/imports/MeeGo/Components
else:DESTDIR = imports/MeeGo/Components
target.path = $$[QT_INSTALL_IMPORTS]/MeeGo/Components

QML_SOURCES += \
    components/ux/*.qml \
    components/ux/*.js \
    components/ux/qmldir \
    components/ux/images/*.png \
    units/*.qml

OTHER_FILES += \
    $${QML_SOURCES}

SOURCES += \
    plugin.cpp

HEADERS += \
    plugin.h

qmldir.files += $$QML_SOURCES
qmldir.path  += $$[QT_INSTALL_IMPORTS]/MeeGo/Components
INSTALLS += target qmldir
