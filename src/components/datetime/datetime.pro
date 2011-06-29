TEMPLATE = lib

TARGETPATH = MeeGo/Ux/Components/DateTime

TARGET = meego-ux-components-datetime

QT += declarative

CONFIG += plugin

SOURCES += fuzzydatetime.cpp \
        plugin.cpp

HEADERS += fuzzydatetime.h \
        plugin.h

QML_FILES = qmldir \
        DatePicker.qml \
        TimePicker.qml

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH
target.depends += link

link.commands += mkdir -p ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/ && 
link.commands += ln -fs ../Ux/Components/DateTime/lib$${TARGET}.so ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so &&
link.commands += mkdir -p ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/ && 
link.commands += ln -fs ./DateTime/lib$${TARGET}.so ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so
QMAKE_EXTRA_TARGETS += link

INSTALLS += target qmlfiles
