import QtQuick 2.0
import Sailfish.Silica 1.0

// Clock
Rectangle {
    id: bgRect
    width: parent.width / 4
    anchors {
        top: parent.top
        topMargin: - 5
        horizontalCenter: parent.horizontalCenter
    }



    Rectangle {
        id: clockRect
        color: Theme.secondaryColor
        border.color: Theme.primaryColor
        border.width: 1
        opacity: 0.3

        radius: 5
        smooth: true

        height: 50
        width: parent.width

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
    }
    // Label can't be clockRect's child, because it would inherit the opacity
    Label {
        id: clockText
        text: "12:34"
        opacity: 1.0
        color: Theme.primaryColor
        anchors.horizontalCenter: clockRect.horizontalCenter
        anchors.verticalCenter: clockRect.verticalCenter
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: Qt.application.active == true
        repeat: true
        onTriggered: {
            console.debug("Tik / tak")

            var offsetDay = new Date()
            clockText.text =  Qt.formatDateTime(offsetDay, "hh:mm:ss")
        }
    }
}
