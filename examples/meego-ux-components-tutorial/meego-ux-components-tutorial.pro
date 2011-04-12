TEMPLATE = subdirs
CONFIG += ordered
TARGET =+ MeeGo-Components

SUBDIRS += step1 \
           step2 \
           step3 \
           step4 \
           step5 \
           step6


OTHER_FILES += meego-ux-components-tutorial.qdoc
