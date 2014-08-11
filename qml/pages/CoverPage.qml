import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "../js/HSL-functions.js" as HSL
import "../elements" as Elements

CoverBackground {
    id: appCover


    states: [
        State {
            name: "empty"
            when: selectedLegsModel.count == 0
        },
        State {
            name: "active"
            when: selectedLegsModel.count > 0 && cover.status === Cover.Active
            PropertyChanges {target: logoImage; x: -100 }
            PropertyChanges {target: routeDataColumn; visible: true }
            PropertyChanges {target: emptyCoverActions; enabled: false }
            PropertyChanges {target: bothCoverActions; enabled: true }
            PropertyChanges {target: coverTimer; running: true }

        },
        State {
            name: "passive"
            when: selectedLegsModel.count > 0 && cover.status !== Cover.Active
        }
    ]

    transitions: [
        Transition {
            from: "passive"; to: "active"
            NumberAnimation {
                target: logoImage
                properties: "x"
                duration: 400
            }
        }
    ]

    Timer {
        id: coverTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            updateClocks()
        }
    }


    // update the clocks on the cover
    signal updateClocks()
    onUpdateClocks: {
        // update the upper edge clock
        clock.update()

        var currentStartTime = selectedLegsModel.get(coverView.currentIndex).StartTime
        timeLeft.text = HSL.prettyTimeFromSeconds(HSL.timestampDifferenceInSeconds(null, currentStartTime))
    }


    // this is a placeholder image so we don't show old information
    // Cover.Status: peeking would be cool.
    Image {
        id: logoImage
        width: Theme.iconSizeLarge; height: Theme.iconSizeLarge
        fillMode: Image.PreserveAspectFit
        smooth: true
        x: (appCover.width - Theme.iconSizeLarge) / 2
        anchors.verticalCenter: appCover.verticalCenter
        source: "qrc:logo"
    }

    // transparent film behind routeinfo
    Rectangle {

        x: 0
        y: routeWindow.y -5

        height: routeWindow.height + 10
        width: parent.width


        color: Theme.primaryColor
        opacity: 0.1
    }

    Column {
        id: routeDataColumn
        width: parent.width-12
        anchors.left: appCover.left
        anchors.leftMargin: 6
        spacing: 10
        visible: false

        Elements.Clock {
            id: clock
            width: parent.width / 1.5
            height: 45
            font.pixelSize: Theme.fontSizeMedium
            anchors.horizontalCenter: parent.horizontalCenter
        }



        Elements.LineBreadCrumbs{
            anchors.horizontalCenter: parent.horizontalCenter
            sizeBig: 48
            sizeSmall: 16
            selectedId: coverView.currentIndex
            width: parent.width
        }




        Rectangle {
            id: routeWindow
            clip: true  // this is needed so that only one leg is shown in the cover
            width: parent.width

            height: 100
            color: "transparent"

            ListView {
                id: coverView
                model: selectedLegsModel
                width: parent.width
                interactive: false

                anchors.left: parent.left
                anchors.top: parent.top

                delegate: Column {
                    id: waypointColumn

                    width: appCover.width
                    Row {
                        width: parent.width
                        spacing: 10
                        Label {
                            id: row1
                            text: HSL.timeFromDatetime(StartTime)
                            font.pixelSize: Theme.fontSizeSmall
                        }

                        Elements.LineShield {id: lineShield; lineColor: Theme.highlightColor;}
                    }

                    Label {
                        id: row2
                        text: StartName
                        font.pixelSize: Theme.fontSizeSmall
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }





        Label {
            id: timeLeft
            font.pixelSize: Theme.fontSizeLarge
            width: parent.width
            horizontalAlignment: Text.AlignRight
        }


    }

    CoverActionList {
        id: bothCoverActions
        enabled: false

        CoverAction {
            iconSource: "image://theme/icon-m-previous-song"
            onTriggered: {
                coverView.decrementCurrentIndex()
                updateClocks()
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-m-next-song"
            onTriggered: {
                coverView.incrementCurrentIndex()
                updateClocks()
            }
        }
    }

    CoverActionList {
        id: emptyCoverActions
        enabled: true
    }

}

