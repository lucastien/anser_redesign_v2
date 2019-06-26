import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import TubeHandler 1.0


Item {
    id: expandStripChart
    property alias expWidth: xComp.width
    property alias expHeight: xComp.height
    property TubeHandler tube
    property bool enableDrawing: false
    property int channel
    RowLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            id: xComp
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft
            color: "black"
            Layout.fillWidth: true
            border.color: "white"
            Canvas{
                id: xExpCanvas
                anchors.fill: parent
                onPaint: drawExpChart(true)
            }
        }
        Rectangle{
            id: yComp
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            color: "black"
            Layout.fillWidth: true
            border.color: "white"
            Canvas{
                id: yExpCanvas
                anchors.fill: parent
                onPaint: drawExpChart(false)
            }
        }
    }

    Connections{
        target: tube
        onExpTpChanged: updateExpChart()
    }

    function updateExpChart(){
        console.log("Call drawing expand strip chart for channel" + channel)
        enableDrawing = true;
        xExpCanvas.requestPaint();
        yExpCanvas.requestPaint();
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
