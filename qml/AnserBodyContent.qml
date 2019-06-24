import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import TubeHandler 1.0
Item {
    id: stripContentItem
    property TubeHandler tube
    RowLayout{
        spacing: 0
        anchors.fill: parent

        AnserLocBar{
            id: locBar
            width: 50
            Layout.fillHeight: true
        }

        AnserStripChart{
            id: strip_1
            width: 150
            Layout.fillHeight: true
            tube: stripContentItem.tube
        }
        AnserStripChart{
            id: strip_2
            width: 150
            Layout.fillHeight: true
            tube: stripContentItem.tube
        }
        AnserStripChart{
            id: strip_3
            width: 150
            Layout.fillHeight: true
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

    function updateStripChart(){
        strip_1.drawStrip()
        strip_2.drawStrip()
        strip_3.drawStrip()
    }
}
