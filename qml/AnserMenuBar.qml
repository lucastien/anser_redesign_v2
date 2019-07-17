import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

MenuBar{
    Menu{
        title: qsTr("SCREEN")
        MenuItem{
            text: qsTr("DEFAULT SCREEN")
            onTriggered: {console.log("Default screen triggerred")}
        }
    }

    Menu{
        title: qsTr("SETUP")
        MenuItem{
            text: qsTr("LOAD STD")
            onTriggered: {
                console.log("Start loading std tube")
                anserMain.tubeHanlder.tubeFile = ":/data/003021999999.T"
                anserMain.tubeHanlder.loadTube()
            }
        }
        MenuItem{
            text: qsTr("LOAD TUBE")
            onTriggered: {
                console.log("Start loading std tube")
                anserMain.tubeHanlder.tubeFile = ":/data/005021023102.T"
                anserMain.tubeHanlder.loadTube()
            }
        }
    }

    Menu{
        title: qsTr("RPC")
    }

    Menu{
        title: qsTr("ANALYSIS")
    }

    Menu{
        title: qsTr("NETWORKED")
    }

    Menu{
        title: qsTr("UTIL")
    }

    Menu{
        title: qsTr("TOOL")
    }

}

