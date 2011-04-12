VERSION = 0.2.1
TEMPLATE = subdirs
TARGET = meego-ux-components-tutorial/step6

qmlfiles.files += *.qml images/
qmlfiles.path += $$INSTALL_ROOT/usr/share/$$TARGET

INSTALLS += qmlfiles

OTHER_FILES += main.qml \ Page1.qml

PROJECT_NAME = step6
