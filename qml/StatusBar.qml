import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12


Pane {
    id: statusBarPane
    objectName: "statusBarPane"
    contentHeight: statusBarLayout.implicitHeight
    padding: 6

    property int dpt: -1
    signal expStripSliderChanged(int value)
    Rectangle {
        parent: statusBarPane.background
        width: parent.width
        height: 1
        color: "#444"
    }

    Rectangle {
        parent: statusBarPane.background
        x: parent.width - 1
        width: 1
        height: parent.height
        color: "#444"
    }

    RowLayout {
        id: statusBarLayout
        objectName: "statusBarLayout"
        width: parent.width
        visible: true
        anchors.verticalCenter: parent.verticalCenter

//        Label {
//            id: pointerIconLabel
//            text: slider.value
//            //font.family: "FontAwesome"
//            font.pixelSize: Qt.application.font.pixelSize * 1.2
//            horizontalAlignment: Label.AlignHCenter

//            Layout.preferredWidth: Math.max(26, implicitWidth)
//        }

//        Slider{
//            id: slider
//            from: -50
//            value: 0
//            to: 50
//            stepSize: 1
//            onValueChanged: expStripSliderChanged(value)
//            MouseArea{
//                anchors.fill: parent
//                hoverEnabled: true
//                onWheel: {
//                    if(wheel.angleDelta.y < 0){
//                        slider.increase();
//                    }else{
//                        slider.decrease();
//                    }
//                }
//            }
//        }

//        Label {
//            id: cursorPixelPosLabel
//            objectName: "cursorPixelPosLabel"
//            text: {
//                return "";
//            }

//            // Specify a fixed size to avoid causing items to the right of us jumping
//            // around when we would be resized due to changes in our text.
//            Layout.minimumWidth: cursorMaxTextMetrics.width
//            Layout.maximumWidth: cursorMaxTextMetrics.width

//            TextMetrics {
//                id: cursorMaxTextMetrics
//                font: cursorPixelPosLabel.font
//                text: "9999, 9999"
//            }
//        }

        ToolSeparator {
            padding: 0
            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }

        Rectangle{
            Layout.fillHeight: true
            color: "red"
            width: 500
            Label {
                id: selectionSizeLabel
                anchors.fill: parent
                objectName: "selectionSizeLabel"
                text: "Error message will be displayed here"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                visible: true

                Layout.minimumWidth: selectionAreaMaxTextMetrics.width
                Layout.maximumWidth: selectionAreaMaxTextMetrics.width

                TextMetrics {
                    id: selectionAreaMaxTextMetrics
                    font: selectionSizeLabel.font
                    text: selectionSizeLabel.text
                }
            }
        }

        ToolSeparator {
            padding: 0
            visible: true

            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }

        Label {
            id: speedLbl
            objectName: "speedLbl"
            text: "Speed: ???"
            visible: true

            Layout.minimumWidth: speedLblMetrics.width
            Layout.maximumWidth: speedLblMetrics.width

            TextMetrics {
                id: speedLblMetrics
                font: speedLbl.font
                text: Screen.desktopAvailableWidth
            }

            ToolTip {
                id: control
                delay: 0
                //timeout: 5000
                visible: mouseArea.containsMouse
                contentItem: Text {
                    textFormat: Text.RichText
                    text: "<div><table border='1'><caption><h4>Test stats</h4>"+
                    "</caption><tr bgcolor='#9acd32'><th/><th>Number1</th><th>Number2</th></tr> <tr><th>Line1</th>"+
                       "<td> 0 </td> <td> 1 </td> </tr> <tr><th>Line2</th> <td> 0 </td> <td> 1 </td> </tr>"+
                       "<tr><th>Line3</th> <td> 0 </td> <td> 0 </td> </tr> <tr><th>Line4</th> <td> 1 </td> <td> 0 </td> </tr>"+
                       "<tr><th>Line5</th> <td> 1 </td> <td> 1 </td> </tr> <tr><th>Line6</th> <td> 1 </td> <td> 1 </td> </tr> </div>"
                    font.pointSize: 14
                    color: "#fd3a94"
                }

                background: Rectangle {
                    color: "#fff68f"
                    border.color: "#21be2b"
                }
            }

            MouseArea{
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        ToolSeparator {
            padding: 0
            visible: true

            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }

        Label {
            id: lineLengthLabel
            objectName: "lineLengthLabel"
            text: "DP: " + dpt
            visible: true

            Layout.minimumWidth: lineLengthMaxTextMetrics.width
            Layout.maximumWidth: lineLengthMaxTextMetrics.width

            TextMetrics {
                id: lineLengthMaxTextMetrics
                font: lineLengthLabel.font
                text: Screen.desktopAvailableWidth
            }
        }

        ToolSeparator {
            padding: 0
            visible: true

            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }

        Label {
            id: dateTimeLabel
            objectName: "dateTimeLabel"
            text: "Sat Sep 29 17:49:55 2012"
            visible: true

            Layout.minimumWidth: lineLengthMaxTextMetrics.width
            Layout.maximumWidth: lineLengthMaxTextMetrics.width

            TextMetrics {
                id: dateTimeLabelMetrics
                font: dateTimeLabel.font
                text: Screen.desktopAvailableWidth
            }
        }
    }
}











/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
