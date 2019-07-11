import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import TubeHandler 1.0
ToolBar{
    RowLayout{
        anchors.fill: parent
        spacing: 2        

//        TubeHandler{
//            id: tubeHandler
//            tubeFile: reelInfoTableView.tubeFileName
//        }

        ToolButton{
            text: "FIND"
            Layout.alignment: Qt.AlignLeft
            enabled: reelInfoTableView.currentRow !== -1
            ToolTip{
                text: qsTr("Play the current tube highlighted on Tlist")
                delay: 1000
                timeout: 5000
                visible: parent.hovered
            }
            onClicked: {
                processLoadTube()
            }
        }
        ToolButton{
            text: "PREV"
            Layout.alignment: Qt.AlignLeft
            enabled: reelInfoTableView.currentRow !== -1
            ToolTip{
                text: qsTr("Play the previous tube highlighted on Tlist")
                delay: 1000
                timeout: 5000
                visible: parent.hovered
            }

        }
        ToolButton{
            text: "NEXT"
            enabled: reelInfoTableView.currentRow !== -1
            Layout.alignment: Qt.AlignLeft
            ToolTip{
                text: qsTr("Play the next tube highlighted on Tlist")
                delay: 1000
                timeout: 5000
                visible: parent.hovered
            }
        }
        Item {
            Layout.fillWidth: true
        }
        ToolButton{
            text: "+"
            Layout.alignment: Qt.AlignRight
            ToolTip{
                text: qsTr("Add a sever key button")
                delay: 1000
                timeout: 5000
                visible: parent.hovered
            }
            onClicked:{
                //serverPickKeyDiag.serverKeys = rightPanel.serverKeys
                serverPickKeyDiag.open()
            }
        }
    }

    function processLoadTube(){
        if(tlistWindow.tube){
            tlistWindow.tube.tubeFile = reelInfoTableView.tubeFileName
            if(tlistWindow.tube.loadTube()){
                console.log("The tube was loaded successfully")
            }
        }
    }


    function getPoint(p){
        return tubeHandler.getPoint(p);
    }
}
