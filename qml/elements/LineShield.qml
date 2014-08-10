import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages/../js/HSL-functions.js" as HSL

Rectangle {
    id: lineContainer
    property color lineColor

    width:  lineIcon.width + lineNumber.width + 4
    height: lineIcon.height + 4

    color: "transparent"
    border.color: lineColor
    border.width: 1
    radius: 5
    smooth: true


    // logic for the lineShieldText
    Component.onCompleted: {
        var lineShieldText
        if (Type == "walk") {
            lineShieldText = HSL.formatLength(Length)
        } else if (Type == "wait") {
            lineShieldText = (Duration/60) + "min"
        } else {
            lineShieldText = HSL.makeLineCode(JORECode)
            lineNumber.font.bold = true
        }
        lineNumber.text = lineShieldText
    }

    Image {
        id: lineIcon
        width: 32; height: 32
        anchors.left: lineContainer.left
        anchors.leftMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        smooth: true

        source: "qrc:" + HSL.transportIcon(Type)
    }

    Label {
        id: lineNumber
        width: 70
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: lineIcon.right
        anchors.leftMargin: 3
        font.pixelSize: Theme.fontSizeSmall

        // text: set in JS logic above
        color: lineColor
    }


}
