VERSION = 0.1.0
TEMPLATE = subdirs
TARGET = meego-ux-tutorial/step4

qmlfiles.files += *.qml images/
qmlfiles.path += $$INSTALL_ROOT/usr/share/$$TARGET

INSTALLS += qmlfiles

OTHER_FILES += main.qml

PROJECT_NAME = step4
