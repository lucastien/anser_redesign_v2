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
            expStripWidth: liss_1.expWidth
            tube: stripContentItem.tube
        }
        AnserStripChart{
            id: strip_2
            width: 150
            Layout.fillHeight: true
            currentChan: 4
            expStripWidth: liss_1.expWidth
            tube: stripContentItem.tube
        }
        AnserStripChart{
            id: strip_3
            width: 150
            currentChan: 5
            Layout.fillHeight: true
            expStripWidth: liss_1.expWidth
            tube: stripContentItem.tube
        }
        AnserLissajous{
            id: liss_1
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        AnserLissajous{
            id: liss_2
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        AnserLissajous{
            id: liss_3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
//        Item {
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//        }
    }

    Connections{
        target: strip_1
        onCursorYChanged: {
            strip_2.cursorY = strip_1.cursorY
            strip_3.cursorY = strip_1.cursorY
        }
    }

    Connections{
        target: strip_2
        onCursorYChanged: {
            strip_1.cursorY = strip_2.cursorY
            strip_3.cursorY = strip_2.cursorY
        }
    }

    Connections{
        target: strip_3
        onCursorYChanged: {
            strip_1.cursorY = strip_3.cursorY
            strip_2.cursorY = strip_3.cursorY
        }
    }


    function updateStripChart(){
        strip_1.drawStrip()
        strip_2.drawStrip()
        strip_3.drawStrip()
    }
}
