TEMPLATE = lib

TARGETPATH = MeeGo/Ux/Gestures

TARGET = meego-ux-gestures

QT += declarative

CONFIG += plugin

SOURCES += qdeclarativegesturearea.cpp \
        qdeclarativegesturehandler.cpp \
        qdeclarativegesturerecognizers.cpp \
        plugin.cpp

HEADERS += qdeclarativegesturearea_p.h \
        gestureareaplugin_p.h \
        qdeclarativegesturehandler_p.h \
        qdeclarativegesturerecognizers_p.h

QML_FILES = qmldir

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

system(ln -fs ../Ux/Gestures/lib$${TARGET}.so $$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so)
system(ln -fs ../Gestures/lib$${TARGET}.so $$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so)

INSTALLS += target qmlfiles
