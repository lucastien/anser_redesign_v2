import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: anserMain
    visible: true
    width: Screen.width
    height: Screen.height - 50
    title: qsTr("Anser Application Demo")

    menuBar: AnserMenuBar{

    }

    header: AnserToolBar{

    }

    AnserBodyContent{
        anchors.fill: parent
    }

    footer: AnserFooterBar{

    }
}
