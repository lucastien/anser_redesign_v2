import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
import "base"
Item {
    id: locBar
    property TubeHandler tube
    property int scale: 1

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        visible: true

        SelectionBox{
            Layout.fillWidth: true
            text: locBar.scale.toString()
            onClicked: {
                if(mouseButton === Qt.LeftButton){
                    changeScale(1)
                }
                if(mouseButton === Qt.RightButton){
                   changeScale(-1)
                }
            }
            onWheeled: {
                if(angleY < 0){
                    changeScale(1)
                }else{
                    changeScale(-1)
                }
            }
        }


        Rectangle{
            id: locArea
            color: "#262222"
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: Global.StripChartBorder
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
