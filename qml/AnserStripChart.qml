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

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        ChannelScroller{
            id: chanScoller
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            currentChan: 3
            onCurrentChanChanged: {                
                drawStrip()
            }
        }

        StripChartItem{
            id: stripArea
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
            avgPoint: 0
            fillColor: Global.StripChartColor
            onCursorWidthChanged: {
                stripChart.cursorWidth = stripArea.cursorWidth
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
                //onHeightChanged: stripChart.cursorWidth = height;

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


    function drawStrip(){
        console.log("Call drawing stripchart on channel " + currentChan)
        if(tube){
            stripArea.pushData(tube.getChannel(currentChan));
        }
    }


}







/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
