import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import TubeHandler 1.0
import "base"

Item {
    id: channelPicker
    property alias channel: switchChan.currentChan
    property int spanVal
    property int rotVal
    property TubeHandler tube
    RowLayout{
        Layout.fillWidth: true
        spacing: 0
        SelectionBox{
            text:  spanVal? spanVal.toString():""
            width: 50
        }
        ChannelScroller{
            id: switchChan
            Layout.fillWidth: true
        }
        SelectionBox{
            text: rotVal? rotVal.toString(): ""
            width: 50
        }
    }
}

