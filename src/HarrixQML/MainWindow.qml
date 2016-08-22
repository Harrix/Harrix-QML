import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "."

ApplicationWindow {
    id: mainWindow
    objectName: "mainWindow"

    property alias content: contentLoader.sourceComponent
    property alias head: head
    property alias navigationDrawer: navigationDrawer

    property bool mobileMode: false

    property int marginCommon: SettingsHarrixQML.marginCommon
    property int spacingCommon: SettingsHarrixQML.spacingCommon
    property int widthTransitionInMobileMode: 640

    visibility: "Maximized"

    NavigationDrawer {
        id: navigationDrawer
        drawer: drawer
        signalSender: mainWindow
    }

    Column {
        id: mainColumn
        height: parent.height
        width: widthPaneRight ()
        y: 0
        z: navigationDrawer.zNavigationDrawer-1
        anchors.margins: 0
        anchors.left: navigationDrawer.right
        spacing: 0

        Head {
            id: head
            signalSender: mainWindow
        }

        Rectangle {
            id: contentPanel
            height: parent.height - head.height
            width: parent.width
            y: 0
            anchors.margins: 0

            Loader {
                id: contentLoader
                anchors.fill: parent
                anchors.margins: 0
                clip: true
            }
        }
    }

    onWidthChanged:  checkMobileMode();
    onHeightChanged: checkMobileMode();

    function checkMobileMode () {
        if ((mainWindow.width <= widthTransitionInMobileMode)
                ||(mainWindow.width < mainWindow.height))
            mobileMode = true;
        else
            mobileMode = false;
    }

    function widthPaneRight () {
        if (mobileMode)
            return mainWindow.width
        else
            return mainWindow.width - navigationDrawer.width
    }
}
