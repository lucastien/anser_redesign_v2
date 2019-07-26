import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
import App 1.0
Item {
    id: stripChart
    property TubeHandler tube
    property var points
    property alias currentChan: chanScoller.currentChan
    property alias xavg_p: stripArea.avgPoint
    property alias stripWidth: stripArea.width
    property alias stripHeight: stripArea.height
    property bool enablePaintStrip: false
    property alias cursorY: cursorRect.y
    property alias cursorWidth: cursorRect.height
    property int expStripHeight

    signal scaleChanged(int inc)

    function pixToDpt(center){
        return stripArea.pixToDpt(center)
    }

    function drawStrip(){
        console.log("Call drawing stripchart on channel " + currentChan)
        if(tube){
            var mode = chanScoller.mode;
            stripArea.clear();
            chanScoller.channel = tube.getChannel(currentChan);
            switch(mode){
            case StripChanItem.ModeType.Current:
                stripArea.pushData(tube.getChannel(currentChan), anserMain.currentColor);
                break;
            case StripChanItem.ModeType.History:
                stripArea.pushData(tube.getHistChannel(currentChan), anserMain.historyColor);
                break;
            case StripChanItem.ModeType.Base:
                stripArea.pushData(tube.getBaseChannel(currentChan), anserMain.baseColor);
                break;
            case StripChanItem.ModeType.CH:
                stripArea.pushData(tube.getChannel(currentChan), anserMain.currentColor);
                stripArea.pushData(tube.getHistChannel(currentChan), anserMain.historyColor);
                break;
            case StripChanItem.ModeType.CB:
                stripArea.pushData(tube.getChannel(currentChan), anserMain.currentColor);
                stripArea.pushData(tube.getBaseChannel(currentChan), anserMain.baseColor);
                break;
            case StripChanItem.ModeType.HB:
                stripArea.pushData(tube.getHistChannel(currentChan), anserMain.historyColor);
                stripArea.pushData(tube.getBaseChannel(currentChan), anserMain.baseColor);
                break;
            case StripChanItem.ModeType.Combine:
                stripArea.pushData(tube.getChannel(currentChan), anserMain.currentColor);
                stripArea.pushData(tube.getHistChannel(currentChan), anserMain.historyColor);
                stripArea.pushData(tube.getBaseChannel(currentChan), anserMain.baseColor);
                break;
            }
        }
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        StripChanItem{
            id: chanScoller
            Layout.fillWidth: true
            height: 50
            onCurrentChanChanged: {
                drawStrip()
            }
            onModeChanged: {
                drawStrip();
            }
        }

        StripChartItem{
            id: stripArea
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            avgPoint: 0
            fillColor: Global.StripChartColor
            penColor: Global.PenColor
            onCursorWidthChanged: {
                stripChart.cursorWidth = stripArea.cursorWidth
            }
            Rectangle{
                id: cursorRect
                width: stripArea.width
                height: Global.ChannelBoxHeight
                color: "red"
                opacity: 0.5
                x: 0
                y: stripArea.height/2
                onYChanged: stripChart.cursorY = y
                //onHeightChanged: stripChart.cursorWidth = height;
                Canvas{
                    id: cursorCanvas
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.lineWidth = 0.5;
                        ctx.strokeStyle = "white";
                        ctx.beginPath();
                        ctx.moveTo(0, parent.height/2);
                        ctx.lineTo(parent.width, parent.height/2);
                        ctx.stroke();
                    }
                }

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
            stripArea.calCursorWidth(centPix, stripChart.expStripHeight)
            stripArea.scale = tube.scale;
            drawStrip();
        }
    }
}







/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
