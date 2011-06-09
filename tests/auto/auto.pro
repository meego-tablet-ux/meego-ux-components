TARGET =    tst_meego-ux-components
TEMPLATE =  app

include(../components/components.pri)
include(../kernel/kernel.pri)
include(../models/models.pri)

LIBS += -lQtQuickTest$${QT_LIBINFIX}
QT +=   declarative

OBJECTS_DIR =   .obj
MOC_DIR =       .moc
CONFIG +=       warn_on testcase
SOURCES +=      tst_auto.cpp
HEADERS +=      tst_auto.h
DEFINES +=      QUICK_TEST_SOURCE_DIR=\"\\\"$$PWD\\\"\"
DESTDIR =       build

OTHER_FILES +=  ../kernel/*.qml \
		../components/*.qml \
                ../models/*.qml


testcases.files += $$OTHER_FILES
testcases.path += build/

INSTALLS += testcases


