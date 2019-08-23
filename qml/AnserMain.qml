import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
//import QtQuick.Dialogs 1.2

import TubeHandler 1.0
import "tlist"
import "base" as Base
ApplicationWindow {
    id: anserMain
    visible: true
    visibility: Window.Maximized
    title: qsTr("Anser Application Demo")
    property TubeHandler tubeHanlder: tubeH
	property bool historyLoaded: false
    property alias showTooltip: menubar.showTooltip

    property alias currentColor: currentYearColor.color
    property alias historyColor: historyYearColor.color
    property alias baseColor: baseYearColor.color

    signal stripNumChanged(int value)
    signal lissColumnChanged(int value)
    menuBar: Base.AnserMenuBar/*AnserMenuBar*/{
        id:menubar
    }

    header: AnserToolBar{
        id: toolbar
        visible: false;
    }    

    onCurrentColorChanged: {
        updateStripAndLiss();
    }

    onHistoryColorChanged: {
        updateStripAndLiss();
    }

    onBaseColorChanged: {
        updateStripAndLiss();
    }

    function updateStripAndLiss(){
        content.updateScreen();
    }

    Connections{
        target: menubar
        onShowToolBarChecked:{
            toolbar.visible = checked;
        }
    }


    Menu{
        id: toolMenu
        //width: 200
        //height: 100
        x: anserFooterBar.x + 50
        y: anserFooterBar.y - 165
        MenuItem{
            icon.source: "qrc:/images/icons/report.png"
            text: "Reports"
        }
        MenuItem{
            icon.source: "qrc:/images/icons/summary.png"
            text: "Summary"
        }
        MenuItem{
            icon.source: "qrc:/images/icons/message.png"
            text: "Message"
        }
        MenuItem{
            icon.source: "qrc:/images/icons/computer-screen.png"
            text: "Screening"
        }
    }

//    ColorDialog {
//        id: colorDialog
//        title: "Please choose a color"
//        modality : Qt.WindowModal

//        property bool currentYear: false
//        property bool historyYear: false
//        property bool baseYear: false
//        onAccepted: {
//            console.log("You chose: " + colorDialog.color)
//            if(currentYear){
//                currentYearColor.color = colorDialog.color
//            }else if(historyYear){
//                historyYearColor.color = colorDialog.color;
//            }else if(baseYear){
//                baseYearColor.color = colorDialog.color;
//            }
//            close();
//        }
//        onRejected: {
//            console.log("Canceled")
//            close();
//        }
//        //Component.onCompleted: visible = true
//    }

    Menu{
        id: layoutMenu
        x: anserFooterBar.x + 90
        y: anserFooterBar.y - 150

        height:170

        ColumnLayout{
            //anchors.centerIn: parent
            anchors.fill: parent
            anchors.leftMargin: 5
            //anchors.topMargin: 10
            //anchors.topMargin: 20
            //Layout.leftMargin: 5
            spacing: 5
            Item{
                Layout.fillHeight: true
            }
            RowLayout{

                spacing: 5
                Label{
                    text: "Strip Num:"
                }

                SpinBox{
                    id: stripNum
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    value: 2
                    from: 1
                    to: 10
                    onValueChanged: anserMain.stripNumChanged(value)
                }

            }
            RowLayout{
                //anchors.fill: parent
                spacing: 5
                Label{
                    text: "Liss Cols:"
                }

                SpinBox{
                    id: lissColumnNum
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    value: 3
                    from: 1
                    to: 10
                    onValueChanged: anserMain.lissColumnChanged(value)
                }

            }
            RowLayout{
                //anchors.fill: parent
                spacing: 5
                Label{
                    text: "Liss Rows:"
                }
                SpinBox{
                    id: lissRowNum
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    value: 1
                    from: 1
                    to: 5
                }

            }

            RowLayout{
                //anchors.fill: parent
                spacing: 5
                Label{
                    text: "Current Color:"
                }
                Rectangle{
                    id: currentYearColor
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "green"
                    MouseArea{
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: {
//                            colorDialog.currentYear = true;
//                            colorDialog.historyYear = false;
//                            colorDialog.baseYear = false;
//                            colorDialog.open();
                        }
                    }
                }

            }

            RowLayout{
                //anchors.fill: parent
                spacing: 5
                Label{
                    text: "History Color:"
                }
                Rectangle{
                    id: historyYearColor
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "red"
                    MouseArea{
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: {
//                            colorDialog.currentYear = false;
//                            colorDialog.historyYear = true;
//                            colorDialog.baseYear = false;
//                            colorDialog.open();
                        }
                    }
                }

            }

            RowLayout{
                //anchors.fill: parent
                spacing: 5
                Label{
                    text: "Base Color:"
                }
                Rectangle{
                    id: baseYearColor
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "blue"
                    MouseArea{
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: {
//                            colorDialog.currentYear = false;
//                            colorDialog.historyYear = false;
//                            colorDialog.baseYear = true;
//                            colorDialog.open();
                        }
                    }
                }


            }





        }

    }


    ListModel{
        id: logModel
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "error"
            time: "[10:05:45 7/26/2019]"
            content: "Not found report PRI on the result host sgps162"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "warning"
            time: "[08:05:30 7/26/2019]"
            content: "Auto locate has failed at 01H"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
         ListElement{
            type: "info"
            time: "[08:05:30 7/26/2019]"
            content: "The tube R23 C102 was located successfully"
         }
    }

    Menu{
        id: historyMessageMenu
        x: anserFooterBar.x + 1220
        y: anserFooterBar.y - 150
        width: 500
        height: 150
        property int index: 0
            ListView{
                id: historyMessageView
                 anchors.fill: parent
                model: logModel
                clip: true
                focus: true
                currentIndex: historyMessageMenu.index
                function loadImg(type){
                    if(type === "warning")
                        return "qrc:/images/icons/warning.png";
                    if(type === "error")
                        return "qrc:/images/icons/cancel.png"
                    return "qrc:/images/icons/info.png";
                }

                delegate: Rectangle{
                    height: 20
                    //width: parent.width
                    RowLayout{
                        anchors.fill: parent
                        Image{
                            source: historyMessageView.loadImg(type)
                        }
                        Label{
                            text: time

                        }
                        Label{
                            text: content
                        }
                    }
                }

            }
        //}

    }

    AnserBodyContent{
        id: content
        anchors.fill: parent
        tube: anserMain.tubeHanlder
    }


    footer: AnserFooterBar{
        id: anserFooterBar
    }

    TubeHandler{
        id: tubeH       
        onTubeLoaded:{
            console.log("The tube has been loaded successfully")
            historyLoaded = false;
            updateStripAndLiss()
        }
        onHistTubeLoaded: {
            console.log("The history tube has been loaded successfully")
            historyLoaded = true;
            updateStripAndLiss()
        }

    }

    TlistWindow{
        id: tlistWindow
        visible: false
        tube: anserMain.tubeHanlder
    }


}
