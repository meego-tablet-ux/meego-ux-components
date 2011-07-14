TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS += common \
        datetime \
        indicators \
        media \
	inputmethod

TARGETPATH = MeeGo/Ux/Components

QML_FILES = qmldir

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += qmlfiles
