VERSION = 0.1.0
TEMPLATE = subdirs
TARGET = meego-ux-tutorial/step2

qmlfiles.files += *.qml images/
qmlfiles.path += $$INSTALL_ROOT/usr/share/$$TARGET

INSTALLS += qmlfiles

OTHER_FILES += main.qml \
               Page1.qml \
               Page2.qml

PROJECT_NAME = step2
