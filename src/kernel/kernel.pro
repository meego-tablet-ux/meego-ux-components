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
	borderimagedecorator.cpp

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
	borderimagedecorator.h

QML_FILES = qmldir

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += target qmlfiles
