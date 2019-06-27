import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import TubeHandler 1.0

Item {
    id: locBar
    property TubeHandler tube
    property alias scale: scaleBtn.scale

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        visible: true
        Rectangle{
            Layout.fillWidth: true
            height: 50
            color: "#232521"
            border.color: "white"
            Button{
                id: scaleBtn
                property int scale: 1
                anchors.fill: parent
                text: scale.toString()
                spacing: 2
                rightPadding: 0
                leftPadding: 0
                padding: 0
                font.pointSize: 12
                MouseArea{
                    id: mouseScaleBtn
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onWheel: {
                        if(tube){
                            if(wheel.angleDelta.y < 0){
                                changeScale(1)
                            }else{
                                changeScale(-1)
                            }
                        }
                    }
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if(mouse.button === Qt.LeftButton){
                            changeScale(1)
                        }
                        if(mouse.button === Qt.RightButton){
                           changeScale(-1)
                        }
                    }
                }
            }
        }
        Rectangle{
            id: locArea
            color: "#262222"
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: "white"
            z: locCanvas.z +1
            Canvas{
                id: locCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext('2d');
                    ctx.font = "bold 18px serif";
                    ctx.fillStyle = "white";

                    ctx.fillText("01H", 10, 500);
                    ctx.fillStyle = "red";
                    ctx.fillText("02H", 10, 250);
                }
            }
        }
    }

    function changeScale(inc){
        if(tube && tube.maxScale(locArea.height) !== -1){
            scale = scale + inc
            if(scale > tube.maxScale(locArea.height)){
                scale = tube.maxScale(locArea.height)
            }
            if(scale < 1){
                scale = 1
            }
            console.log("Scale value = " + scale)
            if(tube.scale !== scale)
                tube.scale = scale;
        }
    }
}





/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
