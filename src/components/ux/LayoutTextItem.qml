
import Qt 4.7

Text {
    id: textItem

    property real minWidth: 0
    property real maxWidth: 10000

    property real dynamicWidth: 0

    Rectangle {
        anchors.fill: parent
        color:  "pink"
        opacity: 0.7
        z: -1
    }

    function updateWidth(){
        elide = Text.ElideNone
        dynamicWidth = paintedWidth

        console.log(" === " , dynamicWidth)

        if( dynamicWidth > maxWidth ){
            dynamicWidth = maxWidth
        }
        if( dynamicWidth < minWidth ){
            dynamicWidth = minWidth
        }
        if( dynamicWidth < 0 ){
            dynamicWidth = 0
        }
        elide = Text.ElideRight
        console.log(" ===> " , dynamicWidth)
    }

    width: dynamicWidth

    onTextChanged: { updateWidth() }
    onFontChanged: { updateWidth() }
    onMinWidthChanged: updateWidth()
    onMaxWidthChanged: updateWidth()
    Component.onCompleted: updateWidth()
}
