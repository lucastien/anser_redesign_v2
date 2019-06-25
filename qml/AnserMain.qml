import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
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

    AnserBodyContent{
        id: content
        anchors.fill: parent
        tube: anserMain.tubeHanlder
    }


    footer: AnserFooterBar{

    }

    TubeHandler{
        id: tubeH       
        onTubeLoaded:{
            console.log("On tube loaded event")
            updateStripChart()
        }
    }

    TlistWindow{
        id: tlistWindow
        visible: false
        tube: anserMain.tubeHanlder
    }

    function updateStripChart(){
        console.log("Will update strip chart later")
        content.updateStripChart()
    }
}
