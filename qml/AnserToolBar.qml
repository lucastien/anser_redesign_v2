import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
//import "qrc:/Icon.js" as MdiFont
ToolBar {
    id: anserToolBar
    signal tlistClicked()
    RowLayout{
        anchors.fill: parent
        spacing: 5

        AnserToolButton{
            id: tlistLaunchBtn
            text: qsTr("TLIST")
            //font.family: "Material Design Icons"
            Layout.leftMargin: 20
            Layout.alignment: Qt.AlignLeft
            onClicked: {
                //tlistWindow.show()
                anserToolBar.tlistClicked();
            }
        }

        AnserToolButton{
            id: sumaryBtn
            text: qsTr("SUMMARY")
            Layout.alignment: Qt.AlignLeft
            onClicked: {tlistWindow.show()}
        }

        AnserToolButton{
            id: messageBtn
            text: qsTr("SCREENING")
            Layout.alignment: Qt.AlignLeft
            onClicked: {console.log("SCREENING is not implemented yet")}
        }

        AnserToolButton{
            id: reportBtn
            text: qsTr("REPORTS")
            Layout.alignment: Qt.AlignLeft
            onClicked: {console.log("REPORTS is not implemented yet")}
        }

        Item {
            Layout.fillWidth: true
        }
    }
}
