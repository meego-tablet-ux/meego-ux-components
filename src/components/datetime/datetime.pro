TEMPLATE = subdirs # XXX: Don't call the linker

TARGETPATH = MeeGo/Ux/Components/DateTime

QML_FILES = qmldir \
        DatePicker.qml \
        TimePicker.qml

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += qmlfiles
