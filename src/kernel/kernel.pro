TEMPLATE = lib

TARGETPATH = MeeGo/Ux/Kernel

TARGET = meego-ux-kernel

QT += declarative

CONFIG += plugin \
        link_pkgconfig

PKGCONFIG += mlite \
        x11 \
        xcomposite \
        xdamage

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
        saverestorestate.cpp

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
        saverestorestate.h

QML_FILES = Theme.qml \
            qmldir

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

system(mkdir -p $$[QT_INSTALL_IMPORTS]/MeeGo/Components/    && ln -fs ../Ux/Kernel/lib$${TARGET}.so $$[QT_INSTALL_IMPORTS]/MeeGo/Components/lib$${TARGET}.so)
system(mkdir -p $$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/ && ln -fs ../Kernel/lib$${TARGET}.so $$[QT_INSTALL_IMPORTS]/MeeGo/Ux/Components/lib$${TARGET}.so)

INSTALLS += target qmlfiles
