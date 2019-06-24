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

                        console.log("Switch to channel " + currentChan)
                        drawStrip()
                    }
                }

            }
        }

        Rectangle{
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "black"
            border.color: "white"
            z: myCanvas.z + 1
            Canvas{
                id: myCanvas
                anchors.fill:parent

                onPaint: paintStripChart()
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        if((mouse.button === Qt.LeftButton) && (mouse.modifiers & Qt.ControlModifier)){
                            xavg_p = mouseY;
                            drawStrip();
                        }
                    }
                }
            }
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
        console.log("Call drawing stripchart")
        if(tube){
            clearCanvas()
            points = tube.getDrawPointList(currentChan, xavg_p, myCanvas.width, myCanvas.height);
            myCanvas.requestPaint();
        }
    }
    function getPoint(p){
        return tube.getPoint(p);
    }
    function paintStripChart(){
        console.log("Paint strip chart")
        if(points > 0){
            var ctx = myCanvas.getContext("2d")
            ctx.lineWidth = 1;
            ctx.strokeStyle = "white"
            ctx.beginPath()
            for(var i = 0; i < points - 1; i++){
                var point = getPoint(i)
                var nextPoint = getPoint(i+1);
                ctx.moveTo(point.x, point.y);
                ctx.lineTo(nextPoint.x, nextPoint.y)
            }
            ctx.stroke()
        }
    }
    Component.onCompleted: {
        console.log("Strip chart initialize")

    }

}
