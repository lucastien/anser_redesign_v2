import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global

Item {
    id: expandStripChart
    property alias expWidth: xComp.width
    property alias expHeight: xComp.height
    property TubeHandler tube
    property bool enableDrawing: false
    property int channel
    property int expWin: 20
    Rectangle{
        id: xyComp
        anchors.fill: parent
        Rectangle{
            id: xComp
            height: xyComp.height
            width: xyComp.width/2
            anchors.left: xyComp.left
            color: Global.LissajousColor
            border.color: Global.LissajousBorder
            Canvas{
                id: xExpCanvas
                anchors.fill: parent
                onPaint: drawExpChart(true)
            }
        }
        Rectangle{
            id: yComp
            height: xyComp.height
            width: xyComp.width/2
            anchors.left: xComp.right
            color: Global.LissajousColor
            border.color: Global.LissajousBorder
            Canvas{
                id: yExpCanvas
                anchors.fill: parent
                onPaint: drawExpChart(false)
            }
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

    Connections{
        target: tube
        onExpTpChanged: updateExpChart()
    }

    function requestUpdateExpWin(){
        winExpCanvas.requestPaint()
    }

    function updateExpWin(mouseY){
        expandStripChart.expWin = Math.abs(xyComp.height/2 - mouseY)
        tube.npt = expandStripChart.expWin * 2
        tube.pt0 = tube.expTp + tube.expHeight/2 - expandStripChart.expWin;
        winExpCanvas.requestPaint()
    }

    function updateExpChart(){
        enableDrawing = true;
        xExpCanvas.requestPaint();
        yExpCanvas.requestPaint();
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

    function drawExpChart(left)
    {
        var ctx = createContext(left);
        ctx.reset()
        if(enableDrawing){
            var nPoints = tube.calExpPoints(channel, left)
            ctx.lineWidth = 1;
            ctx.strokeStyle = "white"
            ctx.beginPath()
            for(var i = 0; i < nPoints - 1; i++){
                var point = tube.getExpPoint(i)
                var nextPoint = tube.getExpPoint(i+1);
                ctx.moveTo(point.x, point.y);
                ctx.lineTo(nextPoint.x, nextPoint.y)
            }
            ctx.stroke()
        }

    }
    function createContext(left){
        var ctx;
        if(left){
            ctx = xExpCanvas.getContext("2d")
        }else{
            ctx = yExpCanvas.getContext("2d")
        }
        return ctx;
    }

}























/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
