INCLUDEPATH += components/

include(ux/ux.pri)

SOURCES +=  \
    components/volumecontrol.cpp \
    components/batteryindicator.cpp \
    components/bluetoothindicator.cpp \
    components/notificationindicator.cpp \
    components/localtime.cpp \
    components/musicindicator.cpp \    
    components/networkindicator.cpp \
    components/borderimagedecorator.cpp

HEADERS +=  \
    components/volumecontrol.h \
    components/batteryindicator.h \
    components/bluetoothindicator.h \
    components/localtime.h \
    components/notificationindicator.h \
    components/musicindicator.h \    
    components/networkindicator.h \
    components/borderimagedecorator.h
