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

