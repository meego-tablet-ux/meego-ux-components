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
target.depends += link

link.commands += mkdir -p ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/ && 
link.commands += ln -fs ../Ux/Units/lib$${TARGET}.so ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so &&
link.commands += mkdir -p ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/ && 
link.commands += ln -fs ../Units/lib$${TARGET}.so ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so
QMAKE_EXTRA_TARGETS += link

INSTALLS += target qmlfiles

