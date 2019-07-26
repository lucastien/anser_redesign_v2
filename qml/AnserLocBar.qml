import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.XmlListModel 2.12
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
import "base"
Item {
    id: locBar
    property TubeHandler tube
    property int scale: 1

    onScaleChanged: {
        locCanvas.requestPaint();
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

    function updateLocBar(){
        var ctx = locCanvas.getContext('2d');
        //ctx.clear();
        ctx.clearRect(0, 0, locCanvas.width, locCanvas.height);
        if(locateMode.state == "manual") return;
        ctx.font = "bold 14px serif";

        console.log("Number of lm items:" + model.count);
        for(var i = 0; i < model.count; i++){
            var name = model.get(i).name;
            var pt0 = model.get(i).pt0;
            var npt = model.get(i).npt;
            var px = dptToPixel(pt0 + npt/2);
            var rect = npt/scale;
            //console.log("Name = " + name + ", pt0 = " + pt0 + ", npt = " + npt + ", px = " + px);
            ctx.beginPath();
            ctx.strokeStyle = "white";
            ctx.lineWidth = 1.5;
            ctx.moveTo(0, px);   // Begin first sub-path
            ctx.lineTo(10, px);
            ctx.stroke();
            ctx.fillStyle = "white";
            ctx.fillText(name, 12, px+4);
            ctx.fillStyle = "yellow";
            ctx.fillRect(locCanvas.width - 20, px - rect/2, 20, rect);
        }

    }

    function dptToPixel(pt){
        var tickOff = locArea.height;
        return tickOff - pt/scale;
    }

    XmlListModel{
        id: model
        source: "qrc:/data/Locate_R23C102.xml"
        query: "/autolocate/landmark"
        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "pt0"; query: "pt0/number()" }
        XmlRole { name: "npt"; query: "npt/number()" }
    }

    Connections{
        target: tube
        onLocateFileChanged: {
            console.log("Locate file changed to " + tube.locateFile);
            model.source = tube.locateFile/*"qrc:/data/Locate_R23C102.xml"*/;
            //model.reload();
            locCanvas.requestPaint();
        }
    }

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
                if(wheel.angleDelta.y < 0){
                    changeScale(1)
                }else{
                    changeScale(-1)
                }
            }
        }
        SelectionBox{
            id: locateMode
            Layout.fillWidth: true
            state: "manual"
            states: [
                State {
                    name: "manual"
                    PropertyChanges {
                        target: locateMode
                        text: "MAN"
                        color: Global.LissajousColor
                    }
                },
                State {
                    name: "auto"
                    PropertyChanges {
                        target: locateMode
                        text: "AUT"
                        color: "#11C209"
                    }
                }
            ]
            onClicked: {
                if(state == "manual"){
                    state = "auto";
                }else{
                    state = "manual"
                }
                locCanvas.requestPaint();
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
                    updateLocBar();
                }
            }
        }
    }


}





/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
