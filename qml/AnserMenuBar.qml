import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

MenuBar{
    id: menuBar
    property bool showTooltip: false
    signal showToolBarChecked(bool checked);
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
                anserMain.tubeHanlder.locateFile = "";
                anserMain.tubeHanlder.loadTube()
            }
        }
        MenuItem{
            text: qsTr("LOAD TUBE")
            onTriggered: {
                console.log("Start loading normal tube")
                anserMain.tubeHanlder.tubeFile = ":/data/005021023102.T"
                anserMain.tubeHanlder.locateFile = "qrc:/data/Locate_R23C102.xml"
                anserMain.tubeHanlder.loadTube()
            }
        }
        MenuItem{
            text: qsTr("MULTI YEARS DEMO")
            onTriggered: {
                console.log("Start loading history tube");
                anserMain.tubeHanlder.loadHistTube();
                anserMain.tubeHanlder.loadBaseTube();
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
        MenuItem{
            text: qsTr("Show tooltip")
            checkable: true
            onTriggered: {
                showTooltip = checked
            }
        }
        MenuItem{
            text: qsTr("Show Toolbar")
            checkable: true
            onTriggered: {
                menuBar.showToolBarChecked(checked);
            }
        }
    }

    Menu{
        title: qsTr("TOOL")


    }

}

