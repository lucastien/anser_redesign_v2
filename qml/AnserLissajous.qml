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


    function updateLissAndExp(){
        var mode = switchChan.mode;
        switchChan.channel = tube.getChannel(channel);
        lissajous.clear();
        expandStripChart.clear();
        updateExpWin();
        switch(mode){
        case LissChanItem.ModeType.Current:
            lissajous.pushData(tube.getChannel(channel), anserMain.currentColor);
            expandStripChart.updateChart(tube.getChannel(channel), anserMain.currentColor);
            break;
        case LissChanItem.ModeType.History:
            lissajous.pushData(tube.getHistChannel(channel), anserMain.historyColor);
            expandStripChart.updateChart(tube.getHistChannel(channel), anserMain.historyColor);
            break;
        case LissChanItem.ModeType.Base:
            lissajous.pushData(tube.getBaseChannel(channel), anserMain.baseColor);
            expandStripChart.updateChart(tube.getBaseChannel(channel), anserMain.baseColor);
            break;
        case LissChanItem.ModeType.CH:
            lissajous.pushData(tube.getChannel(channel), anserMain.currentColor);
            lissajous.pushData(tube.getHistChannel(channel), anserMain.historyColor);
            expandStripChart.updateChart(tube.getChannel(channel), anserMain.currentColor);
            expandStripChart.updateChart(tube.getHistChannel(channel), anserMain.historyColor);
            break;
        case LissChanItem.ModeType.CB:
            lissajous.pushData(tube.getChannel(channel), anserMain.currentColor);
            lissajous.pushData(tube.getBaseChannel(channel), anserMain.baseColor);
            expandStripChart.updateChart(tube.getChannel(channel), anserMain.currentColor);
            expandStripChart.updateChart(tube.getBaseChannel(channel), anserMain.baseColor);
            break;
        case LissChanItem.ModeType.HB:
            lissajous.pushData(tube.getHistChannel(channel), anserMain.historyColor);
            lissajous.pushData(tube.getBaseChannel(channel), anserMain.baseColor);
            expandStripChart.updateChart(tube.getHistChannel(channel), anserMain.historyColor);
            expandStripChart.updateChart(tube.getBaseChannel(channel), anserMain.baseColor);
            break;
        case LissChanItem.ModeType.Combine:
            lissajous.pushData(tube.getChannel(channel), anserMain.currentColor);
            lissajous.pushData(tube.getHistChannel(channel), anserMain.historyColor);
            lissajous.pushData(tube.getBaseChannel(channel), anserMain.baseColor);
            expandStripChart.updateChart(tube.getChannel(channel), anserMain.currentColor);
            expandStripChart.updateChart(tube.getHistChannel(channel), anserMain.historyColor);
            expandStripChart.updateChart(tube.getBaseChannel(channel), anserMain.baseColor);
            break;
        }

        //updateExpWin()
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0


        LissChanItem{
            id: switchChan
            Layout.fillWidth: true
            height: 50
        }
        LissajousItem{
            id: lissajous
            fillColor: Global.LissajousColor
            penColor: Global.PenColor
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            MouseArea {
                id: lissArea
                anchors.fill: parent
                hoverEnabled: true

                onMouseXChanged: toolTipLissajous.x = lissArea.mouseX + 15
                onMouseYChanged: toolTipLissajous.y = lissArea.mouseY + 20
            }

            ToolTip {
                id: toolTipLissajous
                delay: 0
                visible: lissArea.containsMouse && anserMain.showTooltip
                contentItem: Text {
                    textFormat: Text.RichText
                    text:
                        "<div>
                            <header style='color:blue;font-weight:bold'>Lissajous</header>
                            <table>
                                <tr><td>&bull; LB</td><td>:</td><td>Make a measurement</td></tr>
                                <tr><td>&bull; Shift + LB</td><td>:</td><td>Make a measurement 180 out</td></tr>
                                <tr><td>&bull; Ctrl + LB</td><td>:</td><td>Make a measurement from balance point</td></tr>
                                <tr><td>&bull; Alt + LB</td><td>:</td><td>Make a measurement on this channel only</td></tr>
                            </table>
                        </div>"
                    font.pointSize: 14
                    color: "#fd3a94"
                }

                background: Rectangle {
                    color: "#fff68f"
                    border.color: "#21be2b"
                }
            }
        }


        LissMeasItem{
            Layout.fillWidth: true
            height: 50
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
            updateLissAndExp();
        }
        onModeChanged:{
            updateLissAndExp();
        }
        onRotChanged:{
            updateLissAndExp();
            rotChanged();
        }
        onSpanChanged:{
            updateLissAndExp();
            spanChanged();
        }
    }

    Connections{
        target: expandStripChart
        onExpTpChanged: {
            updateLissAndExp();
        }
    }

}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
