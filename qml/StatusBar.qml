import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

import "qrc:/Icon.js" as MdiFont

Pane {
    id: statusBarPane
    contentHeight: statusBarLayout.implicitHeight

    property int dpt: -1
    signal expStripSliderChanged(int value)
    signal tlistClicked();


    RowLayout {
        id: statusBarLayout
        width: parent.width
        implicitHeight: 25
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        anchors.leftMargin: 20

        Image{
            source: "qrc:/images/icons/ic_menu_48px.svg"
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.height
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    statusBarPane.tlistClicked();
                }
           }
        }

        Image{
            source: "qrc:/images/icons/ic_apps_48px.svg"
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.height
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(toolMenu.visible){
                        toolMenu.close();
                    }else{
                        toolMenu.open();
                    }
                }
           }
        }

        Image{
            source: "qrc:/images/icons/layout.png"
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.height
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(layoutMenu.visible){
                        layoutMenu.close();
                    }else{
                        layoutMenu.open();
                    }
                }
           }
        }


        ToolSeparator {
            padding: 0
            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }

        Label {
            id: rowLbl
            text: "Row: 23 x Col: 102"
            Layout.alignment: Qt.AlignRight
            width: 200
        }

        ToolSeparator {
            padding: 0
            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }


        Label {
            id: lineLengthLabel
            text: "DP: " + dpt
            Layout.alignment: Qt.AlignRight
            width: 100
        }

        Label {
            id: speedLbl
            text: "Speed: 40"
            Layout.alignment: Qt.AlignRight
            width: 100
        }

        ToolSeparator {
            padding: 0
            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }

        Label {
            id: extentLbl
            text: "Extents: TEH - TEC"
            Layout.alignment: Qt.AlignRight
            width: 100
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Rectangle{
            Layout.fillHeight: true
            color: "red"
            width: 500
            RowLayout{
                anchors.fill: parent
                spacing: 1
                Label {
                    id: selectionSizeLabel
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "Error/Info message will be displayed here"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    visible: true
                }
                Label{
                    Layout.fillHeight: true
                    width: 15
                    Layout.alignment: Qt.AlignRight
                    font.family: "Material Design Icons"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: MdiFont.Icon.chevronUp
                    MouseArea{
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: {
                            if(historyMessageMenu.visible)
                                historyMessageMenu.close();
                            else
                                historyMessageMenu.open();
                        }
                    }
                }
            }

        }

        ToolSeparator {
            padding: 0
            visible: true

            Layout.fillHeight: true
            Layout.maximumHeight: 24
        }

//        Label {
//            id: speedLbl
//            objectName: "speedLbl"
//            text: "Speed: ???"
//            visible: true

//            Layout.minimumWidth: speedLblMetrics.width
//            Layout.maximumWidth: speedLblMetrics.width

//            TextMetrics {
//                id: speedLblMetrics
//                font: speedLbl.font
//                text: Screen.desktopAvailableWidth
//            }

//        }

//        ToolSeparator {
//            padding: 0
//            visible: true

//            Layout.fillHeight: true
//            Layout.maximumHeight: 24
//        }

//        Label {
//            id: lineLengthLabel
//            objectName: "lineLengthLabel"
//            text: "DP: " + dpt
//            visible: true

//            Layout.minimumWidth: lineLengthMaxTextMetrics.width
//            Layout.maximumWidth: lineLengthMaxTextMetrics.width

//            TextMetrics {
//                id: lineLengthMaxTextMetrics
//                font: lineLengthLabel.font
//                text: Screen.desktopAvailableWidth
//                elide: Qt.ElideRight
//            }
//        }

//        ToolSeparator {
//            padding: 0
//            visible: true

//            Layout.fillHeight: true
//            Layout.maximumHeight: 24
//        }
//        Item {
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//        }
        Label {
            id: dateTimeLabel
            text: "Sat Sep 29 17:49:55 2012"
            Layout.alignment: Qt.AlignRight
            width: 200
        }
    }
}











/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
