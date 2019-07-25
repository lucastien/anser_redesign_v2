import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.3
import TubeHandler 1.0
import "tlist"

ApplicationWindow {
    id: anserMain
    visible: true
    visibility: Window.Maximized
    title: qsTr("Anser Application Demo")
    property TubeHandler tubeHanlder: tubeH
	property bool historyLoaded: false
    property alias showTooltip: menubar.showTooltip


    menuBar: AnserMenuBar{
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
        x: anserFooterBar.x + 10
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
