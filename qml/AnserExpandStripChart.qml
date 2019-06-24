import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4
import TubeHandler 1.0


Item {
    id: expandStripChart

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
        }
        Rectangle{
            id: yComp
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            color: "black"
            Layout.fillWidth: true
            border.color: "white"
        }
    }
}



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
