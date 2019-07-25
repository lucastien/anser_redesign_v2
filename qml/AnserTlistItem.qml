import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import TubeHandler 1.0
import "js/AnserGlobal.js" as Global
import "base"
import "tlist"
import "qrc:/Icon.js" as MdiFont

Page {
    id: tlistView
    property TubeHandler tube
    property int scale: 1

    header: TabBar{
        id: tabBar
        width: parent.width
        TabButton {
            text: "TLIST"
            //width: implicitWidth
        }
        TabButton {
            text: "REEL"
            //width: implicitWidth
        }

    }

    StackLayout {
        width: parent.width
        height: parent.height
        currentIndex: tabBar.currentIndex
        TlistTablePro{
            id: tlistTab
            width: parent.width
            height: parent.height
        }
        ReelTabItem {
            id: reelTab
            width: parent.width
            height: parent.height
        }
    }

    footer: ToolBar{
        id: footer
        RowLayout{
            anchors.fill: parent
            ToolButton{
                icon.source: "qrc:/images/icons/ic_keyboard_arrow_left_24px.svg"
            }
            ToolButton{
                icon.source: "qrc:/images/icons/ic_keyboard_arrow_up_24px.svg"
            }
            ToolButton{
                icon.source: "qrc:/images/icons/ic_keyboard_arrow_right_24px.svg"
            }
            ToolButton{
                icon.source: "qrc:/images/icons/ic_add_circle_outline_24px.svg"
            }
        }
    }
}
