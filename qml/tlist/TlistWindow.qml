import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4 as C1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0
import TubeHandler 1.0
ApplicationWindow {
    id: tlistWindow
    visible: true
    width: 770
    height: 600
    title: qsTr("TLIST")

    //Properties for setting server keys
    property var serverNames: ["LCL"]
    property string concatServerList //dirty workaround by using string for settings
                                     //because settings does not work on array type
    property var hostNames: ["localhost"]
    property string concatHostList

    property var mountedList: [true]
    property string concatMountedList
    property TubeHandler tube
    onConcatServerListChanged: {
        serverNames = concatServerList.split("|")
    }
    onConcatHostListChanged: {
        hostNames = concatHostList.split("|")
    }
    onMountedListChanged: {
        var list = concatMountedList.split("|")
        var mountStr
        for (mountStr in list){
            var mounted = mountStr === "true";
            mountedList.push(mounted);
        }
    }

    Component.onDestruction: {
       concatServerList = serverNames.join("|")
        concatHostList = hostNames.join("|")
       concatMountedList = mountedList.toString().replace(",", "|")

    }

    Component.onCompleted: {
        rightPanel.createServerKeyButtons(serverNames, hostNames, mountedList)

    }
    Settings{
        id: settings
        property alias servers: tlistWindow.concatServerList
        property alias hosts: tlistWindow.concatHostList
        property alias mounted: tlistWindow.concatMountedList
    }

    TlistServerKeyComponent{
        id: keyButton
    }

    menuBar: TlistMenuBar{}

    header: TlistToolbar{
        id: tlistToolBar
    }

    TlistServerKeyDialog {
        id: serverPickKeyDiag
        anchors.centerIn: parent
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

    function getPoint(p){
        return tlistToolBar.getPoint(p)
    }

}
