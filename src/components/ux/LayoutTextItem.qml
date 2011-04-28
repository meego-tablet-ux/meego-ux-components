/*!
   \qmlclass LayoutTextItem
   \title LayoutTextItem
   \section1 LayoutTextItem
   This is a basic text item that resizes to its given text. You can control the width of the item with minWidth and maxWidth.
   The automatic resize can be controlled via 'bool autoResize'. Important: If autoResize is true, width and elide will be set by
   the automatic resizing. If autoResize is false, they must be set manually.

   \section2 API properties

      \qmlproperty real maxWidth
      \qmlcm real, defines the maximum width of the text. Text will be elided if it exceeds this width.

      \qmlproperty real minWidth
      \qmlcm real, defines the minimum width of the text. If the text is to narrow, the item itself will keep the minimum width.

  \section2 Signals
  \qmlnone

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      LayoutTextItem {
         id: textItem

         maxWidth: 150
         minWidth: 50

         text: "Hello World"
      }
  \endqml
*/

import Qt 4.7

Text {
    id: textItem

    property real minWidth: 0
    property real maxWidth: 10000

    property bool autoResize: true
    property real dynamicWidth: 0


    function updateWidth(){
        if( !autoResize )
            return

        elide = Text.ElideNone
        dynamicWidth = paintedWidth

        if( dynamicWidth > maxWidth ){
            dynamicWidth = maxWidth
        }
        if( dynamicWidth < minWidth ){
            dynamicWidth = minWidth
        }
        if( dynamicWidth < 0 ){
            dynamicWidth = 0
        }
        width = dynamicWidth
        elide = Text.ElideRight
    }

    elide: Text.ElideRight

    onTextChanged: updateWidth()
    onFontChanged: updateWidth()
    onMinWidthChanged: updateWidth()
    onMaxWidthChanged: updateWidth()
    Component.onCompleted: updateWidth()
    onAutoResizeChanged: updateWidth()
}
