import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
Item {
    id: stripChart
    property TubeHandler tube
    property var points
    property int currentChan: 3
    property int xavg_p: 0
    property alias stripWidth: stripArea.width
    property alias stripHeight: stripArea.height
    property bool enablePaintStrip: false
    property alias cursorY: cursorRect.y
    property alias cursorWidth: cursorRect.height
    property int expStripHeight

    signal scaleChanged(int inc)


    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        ChannelScroller{
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            currentChan: stripChart.currentChan
            onCurrentChanChanged: {
                stripChart.currentChan = currentChan
                if(points)
                    drawStrip()
            }
        }

        Rectangle{
            id: stripArea
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Global.StripChartColor
            border.color: Global.StripChartBorder
            z: myCanvas.z + 1
            Canvas{
                id: myCanvas
                anchors.fill:parent
                onPaint:{
                    paintStripChart()
                }                
            }

            Rectangle{
                id: cursorRect
                width: stripArea.width
                height: Global.ChannelBoxHeight
                color: "#e60707"
                opacity: 0.8
                x: 0
                y: stripArea.height/2
                onYChanged: stripChart.cursorY = y
                onHeightChanged: stripChart.cursorWidth = height;

            }

            MouseArea {
                id: stripMouse
                anchors.fill: parent
                drag.target: cursorRect
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: stripArea.height - cursorRect.height
                onClicked: {
                    if(mouse.button === Qt.LeftButton){
                        cursorRect.y = mouseY - cursorRect.height/2
                        if(mouse.modifiers & Qt.ControlModifier){
                            stripChart.xavg_p = mouseY;
                            drawStrip();
                        }
                    }
                }
                onWheel: {
                    if(tube){
                        console.log("wheel changed "+ wheel.angleDelta.y)
                        if(wheel.angleDelta.y < 0){
                            stripChart.scaleChanged(1)
                        }else{
                            stripChart.scaleChanged(-1)
                        }
                    }
                }

            }
        }
    }

    Connections{
        target: tube
        onScaleChanged: {
            var centPix = cursorRect.y + cursorRect.height/2
            tube.getCursorWidth(centPix, stripChart.expStripHeight)
            drawStrip();
        }
    }

    Connections{
        target: tube
        onCursorWidthChanged: {
            cursorRect.height = tube.cursorWidth
        }
    }

    function clearCanvas(){
        console.log("Clear the canvas");
        var ctx = myCanvas.getContext("2d")
        ctx.reset()
        points = 0
        myCanvas.requestPaint()
    }

    function drawStrip(){
        console.log("Call drawing stripchart on channel " + currentChan)
        if(tube ){
            //clearCanvas()
            enablePaintStrip = true
            myCanvas.requestPaint();
        }
    }
    function getPoint(p){
        return tube.getPoint(p);
    }
    function paintStripChart(){
        console.log("Paint strip chart channel " + currentChan)
        if(enablePaintStrip){
            var ctx = myCanvas.getContext("2d")
            ctx.reset()
            ctx.lineWidth = 1;
            ctx.strokeStyle = "white"
            ctx.beginPath()
            points = tube.getDrawPointList(currentChan, xavg_p);
            for(var i = 0; i < points - 1; i++){
                var point = getPoint(i)
                var nextPoint = getPoint(i+1);
                ctx.moveTo(point.x, point.y);
                ctx.lineTo(nextPoint.x, nextPoint.y)
            }
            ctx.stroke()
            enablePaintStrip = false
        }
    }

}







/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
