import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import TubeHandler 1.0

ColumnLayout{
    Layout.fillWidth: true
    Layout.rightMargin: 10
    Layout.topMargin: 2
    spacing:  0

    property var diskInfo

    //Properties for setting server keys
    property var serverKeys: ["LCL,localhost,true"]
    property string concatServerList: "" //dirty workaround by using string for settings
                                     //because settings does not work on array type

    property TubeHandler tube
    onConcatServerListChanged: {
        serverKeys = concatServerList.split("|")
    }


    Component.onDestruction: {
       concatServerList = serverKeys.join("|")
    }

    Component.onCompleted: {
        createServerKeyButtons(serverKeys)

    }



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
        enabled: diskTableView.count > 0

    }

    Button{
        id: getIndexBtn
        text: "GET INDEX"
        Layout.fillWidth: true
        enabled: diskTableView.count > 0
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

    TlistServerKeyComponent{
        id: keyButton
    }

    Connections{
        target: serverPickKeyDiag
        onServerKeysChanged:{
            serverKeys = serverPickKeyDiag.serverKeys
        }
    }

    function createServerKeyButtons(serverKeys)
    {
        var i;
        for(i = 0; i < serverKeys.length; i++){
            var keys = serverKeys[i].split(",")
            if(keys !== null && keys.length === 3){
                var button = keyButton.createObject(serverKeyLayout);
                button.text = keys[0]
                button.hostName = keys[1]
                button.mounted = keys[2] === "true"? true:false
            }
        }
    }




    function getReelInfo(){
        diskInfo = diskTableView.currentDiskInfo
        tlistController.getReel(diskInfo);
    }
}

