import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
import "js/AnserGlobal.js" as Global
import "base"

SelectionBox{
    property int currentChan: 3
    text: "CH " + currentChan
    onClicked: {
        if(mouseButton === Qt.RightButton){
            currentChan--;
        }else if(mouseButton === Qt.LeftButton){
            currentChan++;
        }
        if(currentChan >= 10)
            currentChan = 0;
        else if(currentChan < 0)
            currentChan = 9;
    }

    onMouseXChanged: toolTip.x = mouseX + 15
    onMouseYChanged: toolTip.y = mouseY + 20

    ToolTip {
        id: toolTip
        delay: 0
        visible: mouseHover && anserMain.showTooltip
        contentItem: Text {
            textFormat: Text.RichText
            text:
                "<div>
                    <header style='color:blue;font-weight:bold'>Channel</header>
                    <table>
                        <tr><td>&bull; LB/RB</td><td>:</td><td>Next/Prev channel</td></tr>
                        <tr><td>&bull; Shift + LB/RB</td><td>:</td><td>Next/Prev channel at same freq</td></tr>
                        <tr><td>&bull; Ctrl + LB/RB</td><td>:</td><td>Next/Prev channel at same coil</td></tr>
                        <tr><td>&bull; Wheel</td><td>:</td><td>Same as LB/RB</td></tr>
                    </table>
                </div>"
            font.pointSize: 14
            color: "#fd3a94"
        }

        background: Rectangle {
            color: "#fff68f"
            border.color: "#21be2b"
        }
    }
}
