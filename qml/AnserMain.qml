import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
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


    menuBar: Base.AnserMenuBar/*AnserMenuBar*/{
        id:menubar
    }

    header: AnserToolBar{
        id: toolbar
        visible: false;
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

    Menu{
        id: layoutMenu
        x: anserFooterBar.x + 90
        y: anserFooterBar.y - 110

        ColumnLayout{
            anchors.centerIn: parent
            anchors.fill: parent
            RowLayout{

                spacing: 5
                Label{
                    text: "Strip Num:"
                }

                SpinBox{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    value: 1
                }

            }
            RowLayout{
                //anchors.fill: parent
                spacing: 5
                Label{
                    text: "Liss Cols:"
                }

                SpinBox{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    value: 1
                }

            }
            RowLayout{
                //anchors.fill: parent
                spacing: 5
                Label{
                    text: "Liss Rows:"
                }
                SpinBox{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    value: 1
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
        x: anserFooterBar.x + 660
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
