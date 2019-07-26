import QtQuick 2.12
import QtQuick.Controls 2.12

ToolTip {
    id: toolTip
    delay: 0
    visible: false
    property string header: ""
    property string content: ""

    contentItem: Text {
        textFormat: Text.RichText
        text:
            "<div>
                <header style='color:blue;font-weight:bold'> " + header + "</header>
                <table>" + content +
                "</table>
            </div>"
        font.pointSize: 14
        color: "#fd3a94"
    }
    background: Rectangle {
        color: "#fff68f"
        border.color: "#21be2b"
    }
}
