TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS += components \
        kernel \
        models \
        units

# XXX: This will install a global import that will be deprecated later.
# import MeeGo.Components should not be used anymore, instead, the
# app developer should import MeeGo.Ux.Components (for all components),
# MeeGo.Ux.Components.Common for a smaller set, MeeGo.Ux.Components.Media
# for media pickers or MeeGo.Ux.Units for display depth information,
# and so on. See documentation for more details.

TARGETPATH = MeeGo/Components

QML_FILES = qmldir

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += qmlfiles
