import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
import "base"
Item {
    id: lissajousItem
    property alias expWidth: expandStripChart.expWidth
    property alias expHeight: expandStripChart.expHeight
    property alias channel: switchChan.currentChan
    property alias expWin: expandStripChart.expWin
    property alias lissWidth: lissajous.width
    property alias lissHeight: lissajous.height
    property TubeHandler tube
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

        Rectangle{
            id: lissajous
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            color: Global.LissajousColor
            border.color: Global.LissajousBorder
            Canvas{
                id: lissCanvas
                anchors.fill: parent
                onPaint: drawLissajous()
            }
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
        onPt0Changed: updateLissajous()
        onNptChanged: updateLissajous()
    }

    Connections{
        target: switchChan
        onCurrentChanChanged: {
            expandStripChart.updateExpChart()
            updateLissajous()
        }
    }

    function updateExpWin(){
        expandStripChart.requestUpdateExpWin()
    }

    function updateLissajous(){
        lissCanvas.requestPaint()
    }

    function drawLissajous()
    {
        var ctx = lissCanvas.getContext("2d");
        ctx.reset()
        var nPoints = tube.calLissPoints(channel)
        ctx.lineWidth = 1;
        ctx.strokeStyle = "white"
        ctx.beginPath()
        for(var i = 0; i < nPoints - 1; i++){
            var point = tube.getLissPoint(i)
            var nextPoint = tube.getLissPoint(i+1);
            ctx.moveTo(point.x, point.y);
            ctx.lineTo(nextPoint.x, nextPoint.y)
        }
        ctx.stroke()

    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
