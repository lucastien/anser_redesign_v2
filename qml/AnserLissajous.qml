import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import TubeHandler 1.0


Item {
    id: lissajousItem

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            id: lissChan
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            height: 50

            color: "black"
            border.color: "white"
        }
        Rectangle{
            id: lissajous
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            color: "black"
            border.color: "white"
        }
        Rectangle{
            id: measBox
            Layout.fillWidth: true
            height: 25
            Layout.alignment: Qt.AlignTop
            color: "black"
            border.color: "white"
        }
        Rectangle{
            id: utilitiesTool
            Layout.fillWidth: true
            height: 25
            Layout.alignment: Qt.AlignTop
            color: "black"
            border.color: "white"
        }
        AnserExpandStripChart{
            id: expandStripChart
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
