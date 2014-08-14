import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages/../js/HSL-functions.js" as HSL
import "../js/Common.js" as JS

Rectangle {
    id: lineContainer
    property color lineColor

    width:  110
    height: lineIcon.height + 4

    color: "transparent"
    border.color: lineColor
    border.width: 1
    radius: 5
    smooth: true

    states: [
        State {
            name: "horizontal"
            AnchorChanges {
                target: lineIcon
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: undefined
            }
            AnchorChanges {
                target: lineNumber
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: undefined
                    top: lineIcon.bottom
                    left: undefined
                }
            }

            PropertyChanges {
                target: lineNumber
                horizontalAlignment: Text.AlignHCenter
                width: parent.width

            }
            PropertyChanges {
                target: lineContainer
                height: lineIcon.height + lineNumber.paintedHeight + Theme.paddingSmall
                width: 70

            }
        }
    ]

    // logic for the lineShieldText
    Component.onCompleted: {
        var lineShieldText
        if (Type == "walk") {
            lineShieldText = JS.formatLength(Length)
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
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "qrc:" + HSL.transportIcon(Type)

        anchors {
            left: lineContainer.left
            leftMargin: 3
            verticalCenter: parent.verticalCenter
        }
    }

    Label {
        id: lineNumber
        font.pixelSize: Theme.fontSizeSmall
        color: lineColor
        width: parent.width - lineIcon.width - 3
        height:  lineIcon.paintedHeight
        verticalAlignment: Text.AlignVCenter

        anchors {
            left: lineIcon.right
            verticalCenter: parent.verticalCenter
            leftMargin: 3
        }
    }


}
