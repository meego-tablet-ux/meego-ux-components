#-------------------------------------------------
#
# Project created by QtCreator 2011-07-11T10:11:47
#
#-------------------------------------------------

QT       += gui

TARGET = ImageProviderCacheTool
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp \
           ../../src/kernel/imageprovidercachectrl.cpp \
           ../../src/kernel/imageprovidercache.cpp

HEADERS += ../../src/kernel/imageprovidercachectrl.h \
           ../../src/kernel/imageprovidercache.h
