import QtQuick 2.0
import Sailfish.Silica 1.0

// Clock
Rectangle {
    id: clock

    property alias font: clockText.font
    property alias running: clockTimer.running

    color: "transparent"


    // update the time on the clock
    signal update()
    onUpdate: {
        var offsetDay = new Date()
        clockText.text =  Qt.formatDateTime(offsetDay, "hh:mm:ss")
    }


    Rectangle {
        id: clockRect
        color: Theme.secondaryColor
        border.color: Theme.primaryColor
        border.width: 1
        opacity: 0.2

        radius: 5
        smooth: true

        height: parent.height
        width: parent.width

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
    }
    // Label can't be clockRect's child, because it would inherit the opacity
    Label {
        id: clockText
        opacity: 1.0
        color: Theme.primaryColor
        anchors.horizontalCenter: clockRect.horizontalCenter
        anchors.verticalCenter: clockRect.verticalCenter
    }

    // timer - doesn't need to be enabled - clock can be used by calling the update signal
    Timer {
        id: clockTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            clock.update()
        }
    }
}
