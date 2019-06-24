import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls.Styles 1.4

Item {
    id: locBar
    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            Layout.fillWidth: true
            height: 50
            color: "blue"
            border.color: "white"
        }
        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "blue"
            border.color: "white"
            Canvas{
                id: locCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext('2d');
                    ctx.font = "bold 18px serif";
                    ctx.fillStyle = "white";

                    ctx.fillText("01H", 10, 500);
                    ctx.fillStyle = "red";
                    ctx.fillText("02H", 10, 250);
                }
            }
        }
    }

}
