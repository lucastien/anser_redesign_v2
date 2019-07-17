import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import TubeHandler 1.0
import "tlist"

ApplicationWindow {
    id: anserMain
    visible: true
    visibility: Window.Maximized
    title: qsTr("Anser Application Demo")
    property TubeHandler tubeHanlder: tubeH



    menuBar: AnserMenuBar{

    }

    header: AnserToolBar{

    }    

    function updateStripAndLiss(){
        content.updateScreen();
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
            updateStripAndLiss()
        }

    }

    TlistWindow{
        id: tlistWindow
        visible: false
        tube: anserMain.tubeHanlder
    }


}
