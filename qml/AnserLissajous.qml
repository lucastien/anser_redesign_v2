import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
import "base"
import App 1.0
Item {
    id: lissajousItem
    property alias expWidth: expandStripChart.expWidth
    property alias expHeight: expandStripChart.expHeight
    property alias channel: switchChan.currentChan
    property alias expWin: expandStripChart.expWin
    property alias lissWidth: lissajous.width
    property alias lissHeight: lissajous.height

    property TubeHandler tube
    property Channel chan: null

    property alias expTp: expandStripChart.expTp

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        RowLayout{
            Layout.fillWidth: true
            spacing: 0
            SelectionBox{
                width: 50
            }
            ChannelScroller{
                id: switchChan
                Layout.fillWidth: true
            }
            SelectionBox{
                width: 50
            }
        }

        LissajousItem{
            id: lissajous
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }
        Rectangle{
            id: measBox
            Layout.fillWidth: true
            height: Global.MeasBoxHeight
            Layout.alignment: Qt.AlignTop
            color: Global.LissajousColor
            border.color: Global.LissajousBorder
        }
        Rectangle{
            id: utilitiesTool
            Layout.fillWidth: true
            height: Global.MeasBoxHeight
            Layout.alignment: Qt.AlignTop
            color: Global.LissajousColor
            border.color: Global.LissajousBorder
        }
        AnserExpandStripChart{
            id: expandStripChart
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            tube: lissajousItem.tube
            channel: lissajousItem.channel
            expWin: lissajousItem.expWin
        }
    }

    Connections{
        target: tube
        onPt0Changed:{
            lissajous.startPoint = tube.pt0
            lissajous.endPoint = (tube.pt0 + tube.npt)
         }
        onNptChanged:{
            lissajous.endPoint = (tube.pt0 + tube.npt)
        }
    }

    Connections{
        target: switchChan
        onCurrentChanChanged: {
            //expandStripChart.channel = channel
            //expandStripChart.updateExpChart()
            lissajous.pushData(tube.getChannel(channel));
        }
    }

    function updateExpWin(){
        expandStripChart.requestUpdateExpWin()
    }

}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
