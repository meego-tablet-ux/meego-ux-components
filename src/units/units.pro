TEMPLATE = lib

TARGETPATH = MeeGo/Ux/Units

TARGET = meego-ux-units

QT += declarative

CONFIG += plugin

SOURCES += plugin.cpp \
        units.cpp \
        units_p.cpp

HEADERS += plugin.h \
        units.h \
        units_p.h

QML_FILES = qmldir \
        Units.qml

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

system(mkdir -p $$[QT_INSTALL_IMPORTS]/MeeGo/Components/    && ln -fs ../Ux/Units/lib$${TARGET}.so $$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so)
system(mkdir -p $$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/ && ln -fs ../Units/lib$${TARGET}.so $$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so)

INSTALLS += target qmlfiles
