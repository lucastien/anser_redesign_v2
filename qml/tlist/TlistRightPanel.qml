import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4 as C1
import QtQuick.Layouts 1.3


ColumnLayout{
    Layout.fillWidth: true
    Layout.rightMargin: 10
    Layout.topMargin: 2
    //            anchors.left: tlistTableView.right
    spacing:  0

    property var diskInfo

    Shortcut{
        sequence: "Ctrl+B"
        onActivated: getIndexBtn.clicked()
    }

    Button{
        text: "UNLOCK OPTICAL TLIST"
        Layout.fillWidth: true
    }

    Button{
        id: getReelBtn
        text: "GET REEL"
        Layout.fillWidth: true
        state: "off"
        enabled: diskTableView.rowCount > 0

    }

    Button{
        id: getIndexBtn
        text: "GET INDEX"
        Layout.fillWidth: true
        enabled: diskTableView.rowCount > 0
        states: [
            State {
                name: "on";
                PropertyChanges{ target: getIndexBtn; flat: true; highlighted: true }
            },
            State {
                name: "off";
                PropertyChanges{ target: getIndexBtn; flat: false; highlighted: false }
            }
        ]
        onClicked:{
            getReelInfo()
            toggle()
        }
        function toggle(){
            if(state == "on"){
                state = "off"
            }else{
                state = "on"
            }
        }
    }
    Button{
        text: "MOUNTED LIST"
        Layout.fillWidth: true
    }

    RowLayout{
        id: serverKeyLayout
    }

    TlistDiskTableView{
        id: diskTableView
    }

    ColumnLayout{
        Layout.fillWidth: true
        Layout.fillHeight: true
        RowLayout{
            spacing: 5
            Label{
                text: qsTr("DISK")
            }
            TextField{
                id: diskFilterBtn
                placeholderText: "ID"
                maximumLength: 5
                Layout.maximumWidth: 50
            }
            Label{
                text: qsTr("SG")
            }
            TextField{
                id: sgFilterBtn
                placeholderText: "SG"
                maximumLength: 2
                Layout.maximumWidth: 20
            }
            Label{
                text: qsTr("ALPHA")
            }
            TextField{
                id: alPhaFilterBtn
                placeholderText: "ALP"
                maximumLength: 5
                Layout.maximumWidth: 50
            }
            Label{
                text: qsTr("L")
            }
            TextField{
                id: legFilterBtn
                placeholderText: "L"
                maximumLength: 1
                Layout.maximumWidth: 15
            }
        }
    }

    function createServerKeyButtons(serverNames, hostNames, mountedList)
    {
        var list = tlistWindow.serverNames
        var i;
        for(i = 0; i < serverNames.length; i++){
            var button = keyButton.createObject(serverKeyLayout);
            button.text = serverNames[i]
            button.hostName = hostNames[i]
            console.log("Mount: " + mountedList[i])
        }
    }

    function storeServerKey( key, host, mount){
        var index = tlistWindow.serverNames.indexOf(key)
        if(index === -1){
            tlistWindow.serverNames.push(key)
            tlistWindow.hostNames.push(host)
            tlistWindow.mountedList.push(mount)
        }else{
            tlistWindow.hostNames[index] = host
            tlistWindow.mountedList[index] = host
        }

    }

    function removeServerKey(key){
        var index = tlistWindow.serverNames.indexOf(key)
        if( index !== -1 && index < root.serverNames.length){
            tlistWindow.serverNames.splice(index, 1)
            tlistWindow.hostNames.splice(index, 1)
            tlistWindow.mountedList.splice(index, 1)
        }
    }
    function getReelInfo(){
        diskInfo = diskTableView.getCurrentDiskInfo()
        tlistController.getReel(diskInfo);
    }
}

