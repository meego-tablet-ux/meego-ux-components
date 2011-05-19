 
import Qt 4.7

Item{
    id: infoBar

    property alias text: textBox.text
    property int verticalMargins: 5
    property int horizontalMargins: 5
    property int animationTime: 200

    function show(){
        showUp.running = true
    }

    function hide(){
        disappear.running = true
    }

    clip: true

    width: 200
    height: 0

    ThemeImage {
        anchors.fill: parent

        source: "image://themedimage/widgets/common/infobar/infobar-background"

        border{
            left: 4
            right: 4
            top: 4
            bottom: 4
        }
    }

    Text{
        id: textBox

        anchors.centerIn: parent
        anchors.leftMargin: infoBar.margins
        anchors.rightMargin: infoBar.margins

        width: parent.width - horizontalMargins * 2

        wrapMode: Text.WordWrap
        textFormat: Text.RichText

        font.bold: true

        opacity: 0
    }

    SequentialAnimation{
        id: showUp
        NumberAnimation {
            target: infoBar
            property: "height"
            to: textBox.height + infoBar.verticalMargins * 2
            duration: animationTime
        }
        NumberAnimation {
            target: textBox
            property: "opacity"
            to: 1
            duration: animationTime
        }
    }

    SequentialAnimation{
        id: disappear
        NumberAnimation {
            target: textBox
            property: "opacity"
            to: 0
            duration: animationTime / 2
        }
        NumberAnimation {
            target: infoBar
            property: "height"
            to: 0
            duration: animationTime
        }
    }
}
