TEMPLATE = subdirs # XXX: Don't call the linker

TARGETPATH = MeeGo/Ux/Components/Common

QML_FILES = qmldir \
        ActionMenu.qml \
        AppPage.qml \
        AppPageStack.qml \
        BottomToolBar.qml \
        BottomToolBarRow.qml \
        Button.qml \
        CCPContextArea.qml \
        CheckBox.qml \
        ContextMenu.qml \
        DropDown.qml \
        ExpandingBox.qml \
        IconButton.qml \
        InfoBar.qml \
        Label.qml \
        LayoutTextItem.qml \
        ModalContextMenu.qml \
        ModalDialog.qml \
        ModalFog.qml \
        ModalMessageBox.qml \
        ModalSpinner.qml \
        PageStack.js \
        PageStack.qml \
        PopupList.qml \
        ProgressBar.qml \
        RadioButton.qml \
        RadioGroup.js \
        RadioGroup.qml \
        ScrollableMusicList.qml \
        SelectionHandleSurface.qml \
        Slider.qml \
        Spinner.qml \
        StatusBar.qml \
        TextEntry.qml \
        TextField.qml \
        ThemeImage.qml \
        TimeSpinner.qml \
        ToggleButton.qml \
        TopItem.qml \
        VerticalLayout.qml \
        VerticalSlider.qml \
        Window.qml \
        WindowSideBar.qml \
        WindowSideBarDelegate.qml

QML_DIRS = images

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

qmldirs.files = $$QML_DIRS
qmldirs.sources = $$QML_DIRS
qmldirs.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += qmlfiles qmldirs
