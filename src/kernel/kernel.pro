TEMPLATE = lib
TARGETPATH = MeeGo/Ux/Kernel
TARGET = meego-ux-kernel
QT += declarative
CONFIG += plugin \
    link_pkgconfig
PKGCONFIG += mlite \
    x11 \
    xcomposite \
    xdamage \
    meegolocale
MOC_DIR = .moc
OBJECTS_DIR = .obj
MOC_DIR = .moc
OBJECTS_DIR = .obj
SOURCES += contextproperty.cpp \
    imageprovidercache.cpp \
    imagereference.cpp \
    memoryinfo.cpp \
    plugin.cpp \
    qmldebugtools.cpp \
    scene.cpp \
    systemiconprovider.cpp \
    themeimageprovider.cpp \
    translator.cpp \
    windowelement.cpp \
    windowiconprovider.cpp \
    windowlistener.cpp \
    borderimagedecorator.cpp \
    imageprovidercachectrl.cpp
HEADERS += contextproperty.h \
    imageprovidercache.h \
    imagereference.h \
    memoryinfo.h \
    plugin.h \
    qmldebugtools.h \
    scene.h \
    systemiconprovider.h \
    themeimageprovider.h \
    translator.h \
    windowelement.h \
    windowiconprovider.h \
    windowinfo.h \
    windowlistener.h \
    borderimagedecorator.h \
    imageprovidercachectrl.h
LIBS += -L \
    ../../lib/saverestore/ \
    -l \
    meegosaverestore
INCLUDEPATH += ../../lib/saverestore
QML_FILES = Theme.qml \
    qmldir
qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH
target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH
target.depends += link
link.commands += mkdir \
    -p \
    ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/ \
    &&
link.commands += ln \
    -fs \
    ../Ux/Kernel/lib$${TARGET}.so \
    ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so \
    &&
link.commands += mkdir \
    -p \
    ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/ \
    &&
link.commands += ln \
    -fs \
    ../Kernel/lib$${TARGET}.so \
    ${INSTALL_ROOT}$$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so
QMAKE_EXTRA_TARGETS += link
INSTALLS += target \
    qmlfiles
