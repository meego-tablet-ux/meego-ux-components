VERSION = 0.2.1
TEMPLATE = subdirs
TARGET = meego-ux-tutorial/step3

qmlfiles.files += *.qml images/
qmlfiles.path += $$INSTALL_ROOT/usr/share/$$TARGET

INSTALLS += qmlfiles

OTHER_FILES += main.qml \
               Page1.qml \
               Page2.qml \
               Page1-2.qml \
               Page2-2.qml \
               Page1-3.qml \
               Page2-3.qml \

PROJECT_NAME = step3
