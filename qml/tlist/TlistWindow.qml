import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import TubeHandler 1.0

ApplicationWindow {
    id: tlistWindow
    visible: true
    width: 770
    height: 600
    title: qsTr("TLIST")
    property TubeHandler tube

    menuBar: TlistMenuBar{}

    header: TlistToolbar{
        id: tlistToolBar
    }

    Settings{
        id: settings
        property alias serverKeys: rightPanel.concatServerList
    }

    TlistServerKeyDialog {
        id: serverPickKeyDiag
        anchors.centerIn: parent
        //serverKeys: rightPanel.serverKeys
    }



    RowLayout{
        anchors.fill: parent
        spacing: 5

        TlistReelInfoTableView{
            id: reelInfoTableView
        }

        TlistRightPanel{
            id: rightPanel
        }

    }


    footer: ToolBar{

    }

}
