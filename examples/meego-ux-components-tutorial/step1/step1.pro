VERSION = 0.2.1
TEMPLATE = subdirs
TARGET = meego-ux-components-tutorial/step1

qmlfiles.files += *.qml images/
qmlfiles.path += $$INSTALL_ROOT/usr/share/$$TARGET

INSTALLS += qmlfiles

OTHER_FILES += main.qml

PROJECT_NAME = step1
