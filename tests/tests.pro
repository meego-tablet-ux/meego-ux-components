TEMPLATE = subdirs

# SUBDIRS = auto

include(kernel/kernel.pri)
include(models/models.pri)
include(components/components.pri)

OTHER_FILES += meego-ux-components-test.qdoc

QMAKE_EXTRA_TARGETS += test
