import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
import "base"
import App 1.0
Item {
    id: lissajousItem
    property alias expWidth: expandStripChart.expWidth
    property alias expHeight: expandStripChart.expHeight
    property alias channel: switchChan.currentChan
    property alias expWin: expandStripChart.expWin
    property alias lissWidth: lissajous.width
    property alias lissHeight: lissajous.height
    property alias startPoint: lissajous.startPoint
    property alias endPoint: lissajous.endPoint
    property int centerCursor: 0
    property TubeHandler tube
    property Channel chan: null

    property alias expTp: expandStripChart.expTp

    signal rotChanged()
    signal spanChanged()


    onExpWinChanged: {
        updateExpWin();
    }

    function updateExpWin(){
        if(centerCursor > 0){
            //var dpt = lissajous.pixToDpt(centerCursor);
            var npt = expWin*2;
            expTp = anserFooterBar.dpt - expHeight/2;
            startPoint = expTp + expHeight/2 - npt/2;
            endPoint = startPoint + npt;
            expandStripChart.updateExpChart()
        }

    }

    function updateSpan(){

        if(lissajous.priChan){
            var channel = lissajous.priChan;
            var span = channel.span * channel.vcon;
            spanBtn.text = String(span.toFixed(2));
            lissajous.update();
            updateExpWin();
            spanChanged();
        }else{
            spanBtn.text = "";
        }
    }

    function updateRot(){
        rotBtn.text = lissajous.priChan? lissajous.priChan.rot.toString():"";
        lissajous.update();
        updateExpWin();
        rotChanged();
    }

    function updateLissAndExp(){
        lissajous.priChan = tube.getChannel(channel);
        updateExpWin()
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        RowLayout{
            Layout.fillWidth: true
            spacing: 0
            SelectionBox{
                id: spanBtn
                width: 50
                onWheeled: {
                    if(lissajous.priChan){
                        var span = lissajous.priChan.span;
                        if(wheel.angleDelta.y < 0){
                            span *= 2;
                        }else{
                            span /= 2;
                        }
                        span = lissajous.boundSpan(span)
                        lissajous.priChan.span = span
                    }
                }
            }
            ChannelScroller{
                id: switchChan
                Layout.fillWidth: true
            }
            SelectionBox{
                id: rotBtn
                width: 50
                onWheeled: {
                    if(lissajous.priChan && (wheel.modifiers & Qt.ControlModifier)){
                        var rot = lissajous.priChan.rot;
                        if(wheel.angleDelta.y < 0){
                            rot += 1;
                        }else{
                            rot -= 1;
                        }
                        if(rot < 0) rot = 359;
                        if(rot > 359) rot = 0;
                        lissajous.priChan.rot = rot
                    }
                }
            }
        }

        LissajousItem{
            id: lissajous
            fillColor: Global.LissajousColor
            penColor: Global.PenColor
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }
        Rectangle{
            id: measBox
            Layout.fillWidth: true
            height: Global.MeasBoxHeight
            Layout.alignment: Qt.AlignTop
            color: Global.LissajousColor
            border.color: Global.LissajousBorder
        }
        Rectangle{
            id: utilitiesTool
            Layout.fillWidth: true
            height: Global.MeasBoxHeight
            Layout.alignment: Qt.AlignTop
            color: Global.LissajousColor
            border.color: Global.LissajousBorder
        }
        AnserExpandStripChart{
            id: expandStripChart
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            tube: lissajousItem.tube
            channel: lissajousItem.channel            
        }
    }

    Connections{
        target: switchChan
        onCurrentChanChanged:{
            var chanObj = tube.getChannel(switchChan.currentChan)
            if(chanObj){
                switchChan.text = chanObj.fullName
            }
            updateLissAndExp();
        }
    }

    Connections{
        target: lissajous
        onPriChanChanged:{
            updateRot()
            updateSpan()
            lissajous.priChan.rotChanged.connect(updateRot);
            lissajous.priChan.spanChanged.connect(updateSpan);
        }
    }

}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
