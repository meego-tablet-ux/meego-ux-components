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

system(ln -fs ../Ux/Components/DateTime/lib$${TARGET}.so $$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so)
system(ln -fs ./DateTime/lib$${TARGET}.so $$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so)

INSTALLS += target qmlfiles
