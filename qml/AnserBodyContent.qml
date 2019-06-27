import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import TubeHandler 1.0
Item {
    id: stripContentItem
    property TubeHandler tube


    Component.onCompleted: {
        console.log("Strip chart initialize")
        tube.stripWidth = strip_1.stripWidth
        tube.stripHeight = strip_1.stripHeight
        tube.expHeight = liss_1.expHeight
        tube.expWidth = liss_1.expWidth
        tube.lissWidth = liss_1.lissWidth
        tube.lissHeight = liss_1.lissHeight
    }

    RowLayout{
        spacing: 0
        anchors.fill: parent

        AnserLocBar{
            id: locBar
            width: 50
            Layout.fillHeight: true
            tube: stripContentItem.tube
        }

        AnserStripChart{
            id: strip_1
            width: 150
            Layout.fillHeight: true
            expStripHeight: liss_1.expWidth
            tube: stripContentItem.tube
            onScaleChanged: {
                console.log("scale changed")
                locBar.changeScale(inc)
            }
        }
        AnserStripChart{
            id: strip_2
            width: 150
            Layout.fillHeight: true
            currentChan: 4
            expStripHeight: liss_1.expWidth
            tube: stripContentItem.tube
            onScaleChanged: {
                locBar.changeScale(inc)
            }
        }
        AnserStripChart{
            id: strip_3
            width: 150
            currentChan: 5
            Layout.fillHeight: true
            expStripHeight: liss_1.expWidth
            tube: stripContentItem.tube
            onScaleChanged: {
                locBar.changeScale(inc)
            }
        }
        AnserLissajous{
            id: liss_1
            Layout.fillWidth: true
            Layout.fillHeight: true
            channel: strip_1.currentChan
            tube: stripContentItem.tube

        }
        AnserLissajous{
            id: liss_2
            Layout.fillWidth: true
            Layout.fillHeight: true
            channel: strip_2.currentChan
            tube: stripContentItem.tube
        }
        AnserLissajous{
            id: liss_3
            Layout.fillWidth: true
            Layout.fillHeight: true
            channel: strip_3.currentChan
            tube: stripContentItem.tube
        }
    }

    Connections{
        target: strip_1
        onCursorYChanged: {
            strip_2.cursorY = strip_1.cursorY
            strip_3.cursorY = strip_1.cursorY
            var center = strip_1.cursorY + strip_1.cursorWidth/2;
            updateDpt(center)
        }
    }

    Connections{
        target: strip_2
        onCursorYChanged: {
            strip_1.cursorY = strip_2.cursorY
            strip_3.cursorY = strip_2.cursorY
            var center = strip_2.cursorY + strip_2.cursorWidth/2;
            updateDpt(center)
        }
    }

    Connections{
        target: strip_3
        onCursorYChanged: {
            strip_1.cursorY = strip_3.cursorY
            strip_2.cursorY = strip_3.cursorY
            var center = strip_3.cursorY + strip_3.cursorWidth/2;
            updateDpt(center)
        }
    }

    Connections{
        target: liss_1
        onExpWinChanged:{
            liss_2.expWin = liss_3.expWin = liss_1.expWin
            liss_2.updateExpWin()
            liss_3.updateExpWin()
        }
    }

    Connections{
        target: liss_2
        onExpWinChanged:{
            liss_1.expWin = liss_3.expWin = liss_2.expWin
            liss_1.updateExpWin()
            liss_3.updateExpWin()
        }
    }
    Connections{
        target: liss_3
        onExpWinChanged:{
            liss_2.expWin = liss_1.expWin = liss_3.expWin
            liss_2.updateExpWin()
            liss_1.updateExpWin()
        }
    }

    function updateDpt(centerCursor){
        anserFooterBar.dpt = tube.pixToDpt(centerCursor);
        tube.expTp = anserFooterBar.dpt - tube.expHeight/2
        tube.npt = liss_1.expWin*2
        tube.pt0 = tube.expTp + tube.expHeight/2 - liss_1.expWin;
    }

    function updateStripChart(){
        strip_1.drawStrip()
        strip_2.drawStrip()
        strip_3.drawStrip()
    }
}
