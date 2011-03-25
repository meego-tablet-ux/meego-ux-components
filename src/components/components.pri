INCLUDEPATH += components/

include(ux/ux.pri)

SOURCES +=  \
    components/gesturearea.cpp \
    components/volumecontrol.cpp \
    components/batteryindicator.cpp \
    components/bluetoothindicator.cpp \
    components/notificationindicator.cpp \
    components/localtime.cpp \
    components/networkindicator.cpp #\
    # components/theme.cpp

HEADERS +=  \
    components/gesturearea.h \
    components/volumecontrol.h \
    components/batteryindicator.h \
    components/bluetoothindicator.h \
    components/localtime.h \
    components/notificationindicator.h \
    components/networkindicator.h #\
    # components/theme.h
