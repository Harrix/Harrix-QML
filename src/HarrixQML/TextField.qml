import QtQuick 2.7
import QtQuick.Controls 2.0
import "."

TextField {
    id: textField

    //Properties that it is necessary to set
    property alias textPlaceholder: placeholderReplace.text

    //Common properties which can be changed if necessary
    property string fontName: SettingsHarrixQML.fontName
    property int fontSize: SettingsHarrixQML.fontSize
    property int fontRenderType: SettingsHarrixQML.fontRenderType
    property int durationAnimation: SettingsHarrixQML.durationAnimation
    property string colorSelection: SettingsHarrixQML.colorRed
    property string colorFontSelection: SettingsHarrixQML.colorLightElement
    property string colorFont: SettingsHarrixQML.colorFont
    property string colorNotEnabled: SettingsHarrixQML.colorNotEnabled
    property string colorFontPlaceholder: SettingsHarrixQML.colorFontPlaceholder
    property string colorTextFieldBorder: SettingsHarrixQML.colorBorder
    property string colorTextFieldBorderHover: SettingsHarrixQML.colorRed

    renderType: fontRenderType
    font.pixelSize: fontSize
    font.family: fontName
    selectionColor: colorSelection
    selectedTextColor: colorFontSelection
    selectByMouse: true
    color: enabled ? colorFont : colorNotEnabled
    placeholderText: ""
    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                                         placeholderReplace.implicitWidth
                                         + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                                          placeholderReplace.implicitHeight
                                          + topPadding + bottomPadding)

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.NoButton
    }

    Text {
        id: placeholderReplace
        x: textField.leftPadding
        y: textField.topPadding
        width: textField.width - (textField.leftPadding + textField.rightPadding)
        height: textField.height - (textField.topPadding + textField.bottomPadding)
        renderType: fontRenderType
        font.pixelSize: fontSize
        font.family: fontName
        color: colorFontPlaceholder
        horizontalAlignment: textField.horizontalAlignment
        verticalAlignment: textField.verticalAlignment
        visible: calculateNormalStatePlaceholder()
        elide: Text.ElideRight
    }

    function calculateNormalStatePlaceholder() {
        var result = !textField.length;
        result = result && !textField.preeditText;
        result = result && !textField.activeFocus;
        return result;
    }

    background: Rectangle {
        y: textField.height - height - textField.bottomPadding / 2
        implicitWidth: 120
        height: textField.activeFocus ? 2 : 1
        color: textField.activeFocus ? colorTextFieldBorderHover : colorTextFieldBorder

        Behavior on color {
            ColorAnimation { duration: durationAnimation }
        }
    }
}
