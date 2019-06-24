import QtQuick 2.12
import QtQuick.Controls 2.12

MenuBar{
    Menu{
        title: qsTr("PRINT")
        MenuItem{
            text: qsTr("Print Screen")
        }
    }

    Menu{
        title: qsTr("UTIL")
        MenuItem{
            text: qsTr("View All Message In Reel")
        }
        MenuItem{
            text: qsTr("Locate Reel For Given Tube And Disk ID")
        }
    }
}
