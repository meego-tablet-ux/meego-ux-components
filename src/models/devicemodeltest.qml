import Qt 4.7
import MeeGo.Tablet 0.1

Item{

    width:480
    height:480

    UDiskDeviceModel{
        id: myModel
    }


    ListView {
        width: 180; height: 200
        model: myModel
        delegate: Text {
            text: deviceLabel 
        }
    }
}

