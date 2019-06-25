import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import TubeHandler 1.0

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
    property int expStripWidth
    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            height: 50
            color: "black"
            border.color: "white"

            Button{
                id: switchChanBtn
                anchors.fill: parent
                text: "Chan " + currentChan
                flat: true
                font.bold: true

                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if(mouse.button === Qt.RightButton){
                            currentChan--;
                        }else if(mouse.button === Qt.LeftButton){
                            currentChan++;
                        }
                        if(currentChan >= 10)
                            currentChan = 0;
                        else if(currentChan < 0)
                            currentChan = 9;
                        if(points){
                            console.log("Switch to channel " + currentChan)
                            drawStrip()
                        }
                    }
                }

            }
        }

        Rectangle{
            id: stripArea
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "black"
            border.color: "white"
            z: myCanvas.z + 1
            Canvas{
                id: myCanvas

                anchors.fill:parent

                onPaint:{
                    paintStripChart()
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        if((mouse.button === Qt.LeftButton) && (mouse.modifiers & Qt.ControlModifier)){
                            stripChart.xavg_p = mouseY;
                            drawStrip();
                        }
                    }
                }
            }

            Rectangle{
                id: cursorRect
                width: stripArea.width
                height: 50
                color: "#e60707"
                opacity: 0.8
                x: 0
                y: stripArea.height/2
                MouseArea {
                    anchors.fill: parent
                    drag.target: cursorRect
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: stripArea.height - cursorRect.height
                }
            }
        }
    }

    Connections{
        target: tube
        onScaleChanged: {
            var centPix = cursorRect.y + cursorRect.height/2
            tube.getCursorWidth(centPix, stripChart.expStripWidth)
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
        if(tube){
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
