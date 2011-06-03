TEMPLATE = subdirs # XXX: Don't call the linker

TARGETPATH = MeeGo/Ux/Components/Media

QML_FILES = qmldir \
        pickerArray.js \
        MusicPicker.qml \
        PhotoPicker.qml \
        VideoPicker.qml

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += qmlfiles
