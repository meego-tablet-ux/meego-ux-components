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

INSTALLS += target qmlfiles
