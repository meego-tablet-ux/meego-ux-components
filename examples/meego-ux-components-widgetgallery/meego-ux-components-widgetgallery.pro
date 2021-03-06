VERSION = 0.2.1
TEMPLATE = subdirs
TARGET = meego-ux-components-widgetgallery

qmlfiles.files += *.qml images/
qmlfiles.path += $$INSTALL_ROOT/usr/share/$$TARGET

INSTALLS += qmlfiles

QML_FILES += *.qml \
    *.js

OTHER_FILES += \
    $${QML_FILES} \

TRANSLATIONS += $${QML_FILES}

PROJECT_NAME = meego-ux-components-widgetgallery
