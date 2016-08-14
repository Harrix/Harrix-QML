import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "."

Rectangle {
    property alias drawer: contentLoader.sourceComponent

    property int minimumWidth: SettingsApp.widthMinimumNavigationDrawer
    property var percentWidthOfParent: "none"
    property int startDragDistance: SettingsApp.startDragDistance
    property int marginCommon: SettingsApp.marginCommon
    property string colorBackground: SettingsApp.colorBackground
    property int easingTypeNavigationDrawer: SettingsApp.easingTypeNavigationDrawer
    property int zNavigationDrawer: 20
    property string type: "fix"
    property string position: "open"

    id: navigationDrawer
    objectName: "navigationDrawer"

    height: parent.height
    width: widthNavigationDrawer ()
    anchors.margins: 0
    y: 0
    x: 0
    z: zNavigationDrawer
    clip: true

    QtObject {
        id: privateVar
        property int previousX: 0
        property bool startDrag: false
    }

    MouseArea {
        id: mouseAreaDrag
        enabled: false

        Rectangle {
            id: dark
            parent: navigationDrawer.parent
            height: parent.height
            width: parent.width
            y: 0
            x: navigationDrawer.width + navigationDrawer.x
            color: "#000"
            z: 19
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: SettingsApp.durationAnimation
                    easing.type: Easing.Linear
                }
            }
        }

        Loader {
            id: contentLoader
            anchors.fill: parent
            anchors.margins: marginCommon
            clip: true
        }

        Rectangle {
            x: parent.width - 2 * startDragDistance
            width: 2 * startDragDistance
            height: parent.height
            color: "#21be2b"

            MouseArea {
                id: mouseAreaStartDrag
                enabled: false
                anchors.fill: parent
                hoverEnabled: true
                //cursorShape: Qt.PointingHandCursor
                onClicked: toogleNavigationDrawer ()

                drag.target: navigationDrawer
                drag.minimumX: -navigationDrawer.width + startDragDistance
                drag.maximumX: 0
                drag.axis: Qt.Horizontal
            }
        }

        anchors.fill: parent
        drag.target: navigationDrawer
        drag.minimumX: -navigationDrawer.width + startDragDistance
        drag.maximumX: 0
        drag.axis: Qt.Horizontal
        drag.filterChildren: true
        onPressed: focus = true
    }

    Behavior on x {
        NumberAnimation {
            duration: SettingsApp.durationAnimation
            easing.type: easingTypeNavigationDrawer
        }
    }

    onXChanged: {
        if ((mouseAreaDrag.drag.active)||(mouseAreaStartDrag.drag.active)) {
            console.log ("drag x = " + x);
            if (privateVar.startDrag === false) {
                privateVar.startDrag = true;
                privateVar.previousX = x;
            }
            else {
                if ((x > -navigationDrawer.width/2)&&(x <= 0)) {
                    if (privateVar.previousX < x) {
                        privateVar.startDrag = false;
                        position = "open";
                        privateVar.previousX = 0;
                        Qt.inputMethod.hide();
                    }
                }
                if ((x >= -navigationDrawer.width)&&(x < -navigationDrawer.width/2)) {
                    if (privateVar.previousX > x) {
                        privateVar.startDrag = false;
                        position = "close";
                        privateVar.previousX = 0;
                        Qt.inputMethod.hide();
                    }
                }
                if (privateVar.startDrag === true)
                    privateVar.previousX = x;
            }
        }
    }

    onTypeChanged: {
        if (type === "fix") {
            position = "open";
            mouseAreaDrag.enabled = false;
            mouseAreaStartDrag.enabled = false;
            dark.opacity = 0;
        }
        if (type === "drawer") {
            position = "close";
            mouseAreaDrag.enabled = true;
            mouseAreaStartDrag.enabled = true;
            dark.opacity = 0;
        }
    }

    onPositionChanged: {
        if (position === "open") {
            navigationDrawer.x = 0;
            if (type === "drawer")
                dark.opacity = 0.3;
            else
                dark.opacity = 0;
        }
        if (position == "close") {
            navigationDrawer.x = -navigationDrawer.width + startDragDistance;
            dark.opacity = 0;
        }
    }

    function toogleNavigationDrawer () {
        if (type === "drawer")
            if (position === "close")
                position = "open";
            else
                position = "close";
    }

    function widthNavigationDrawer () {
        if (percentWidthOfParent === "none")
            width = minimumWidth;
        else
            width = Math.max( parseFloat(percentWidthOfParent) * parent.width, minimumWidth);
    }

    function defineTypeNavigationDrawer (width, height) {
        if ((width <= 640)||(width < height))
            type = "drawer";
        else
            type = "fix";
    }
}
