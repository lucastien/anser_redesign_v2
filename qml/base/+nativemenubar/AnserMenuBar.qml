import QtQuick 2.12
import Qt.labs.platform 1.0 as Platform

Item{
    id: root
    property bool showTooltip: false
    signal showToolBarChecked(bool checked);
    Platform.MenuBar{
        id: menuBar
        Platform.Menu{
            title: qsTr("SCREEN")
            Platform.MenuItem{
                text: qsTr("DEFAULT SCREEN")
                onTriggered: {console.log("Default screen triggerred")}
            }
        }

        Platform.Menu{
            title: qsTr("SETUP")
            Platform.MenuItem{
                text: qsTr("LOAD STD")
                onTriggered: {
                    console.log("Start loading std tube")
                    anserMain.tubeHanlder.tubeFile = ":/data/003021999999.T"
                    anserMain.tubeHanlder.locateFile = "";
                    anserMain.tubeHanlder.loadTube()
                }
            }
            Platform.MenuItem{
                text: qsTr("LOAD TUBE")
                onTriggered: {
                    console.log("Start loading normal tube")
                    anserMain.tubeHanlder.tubeFile = ":/data/005021023102.T"
                    anserMain.tubeHanlder.locateFile = "qrc:/data/Locate_R23C102.xml"
                    anserMain.tubeHanlder.loadTube()
                }
            }
            Platform.MenuItem{
                text: qsTr("MULTI YEARS DEMO")
                onTriggered: {
                    console.log("Start loading history tube");
                    anserMain.tubeHanlder.loadHistTube();
                    anserMain.tubeHanlder.loadBaseTube();
                }
            }
        }

        Platform.Menu{
            title: qsTr("RPC")
        }

        Platform.Menu{
            title: qsTr("ANALYSIS")
        }

        Platform.Menu{
            title: qsTr("NETWORKED")
        }

        Platform.Menu{
            title: qsTr("UTIL")
            Platform.MenuItem{
                text: qsTr("Show tooltip")
                checkable: true
                onTriggered: {
                    root.showTooltip = checked
                }
            }
            Platform.MenuItem{
                text: qsTr("Show Toolbar")
                checkable: true
                onTriggered: {
                    root.showToolBarChecked(checked);
                }
            }
        }

        Platform.Menu{
            title: qsTr("TOOL")
        }

    }


}
