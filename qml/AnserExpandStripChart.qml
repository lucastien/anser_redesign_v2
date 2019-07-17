import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
import App 1.0
Item {
    id: expandStripChart
    property alias expWidth: xComp.width
    property alias expHeight: xComp.height
    property TubeHandler tube
    property bool enableDrawing: false
    property int channel
    property int expWin: 20
    property int expTp: -1
    onExpTpChanged: {        
        updateExpChart()
    }
    onChannelChanged: {
        updateExpChart()
    }

    function requestUpdateExpWin(){
        winExpCanvas.requestPaint()
    }

    function updateExpWin(mouseY){
        expandStripChart.expWin = Math.abs(xyComp.height/2 - mouseY)
        winExpCanvas.requestPaint()
    }

    function updateExpChart(){
        xComp.expTp = expTp
        yComp.expTp = expTp
        xComp.pushData(tube.getChannel(channel))
        yComp.pushData(tube.getChannel(channel))
        requestUpdateExpWin()
    }

    function drawExpWin(){
        var ctx = winExpCanvas.getContext("2d")
        ctx.reset()
        ctx.lineWidth = 1;
        ctx.strokeStyle = "red"
        ctx.beginPath()
        //draw center line
        ctx.moveTo(0, xyComp.height/2);
        ctx.lineTo(xyComp.width, xyComp.height/2)
        //draw lower line
        ctx.moveTo(0, xyComp.height/2 + expWin);
        ctx.lineTo(xyComp.width, xyComp.height/2 + expWin)
        //draw upper line
        ctx.moveTo(0, xyComp.height/2 - expWin);
        ctx.lineTo(xyComp.width, xyComp.height/2 - expWin)

        ctx.stroke()
    }

    Rectangle{
        id: xyComp
        anchors.fill: parent

        ExpStripChartItem{
            id: xComp
            xComponent: true
            height: xyComp.height
            width: xyComp.width/2
            anchors.left: xyComp.left
            fillColor: Global.LissajousColor
        }

        ExpStripChartItem{
            id: yComp
            xComponent: false
            height: xyComp.height
            width: xyComp.width/2
            anchors.left: xComp.right
            fillColor: Global.LissajousColor
        }

        Canvas{
            id: winExpCanvas
            anchors.fill: parent
            onPaint: drawExpWin()
            MouseArea{
                id: expMouse
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                propagateComposedEvents: true                
                hoverEnabled: true
                property bool rightButton: false
                onPressed: {
                    if(mouse.button === Qt.RightButton){
                        rightButton = true;
                        updateExpWin(mouseY)
                    }
                }
                onReleased: rightButton = false
                onPositionChanged: {
                    if(rightButton){
                        updateExpWin(mouseY)
                    }
                }
            }
        }

    }



}























/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
