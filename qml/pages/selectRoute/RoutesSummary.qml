import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "../../js/HSL-functions.js" as HSL
import "../../elements" as Elements
import "../../models" as Models
import "../../js/Common.js" as JS

// Show routes summary
Repeater {
    id: routes
    model: routeModel


    delegate: BackgroundItem {
        id: routeBackground
        height: routeHeader.height + minimizedView.height
        anchors.bottomMargin: 30
        clip: true // clipping on, so that route details are hidden when minimized


        // the opacity that changes depending on if it's even or odd row
        property real rowOpacity: 0.15 - (index % 2) *0.1

        // what happens when you click a route
        onClicked: {
            var newState

            // on second click return to defaults
            if (lastClickedRouteSummary == index) {
                newState = ""
                routeDetails.hide()
                lastClickedRouteSummary = -1
            } else

            // first click shows details and hides other
            {
                newState = "detailed"
                routeDetails.show(index)
                lastClickedRouteSummary = index

                // Add new legs to selectedLegsModel
                mainWindow.selectedLegsModel.removeLegsFromPage(pageStack.depth) // remove this level's old selection
                mainWindow.selectedLegsModel.addLegs(Legs, pageStack.depth) // add new selection
                mainWindow.coverPage.resetCover()


            }

            //  show details for the clicked, minimize others
            for (var i = 0; i < routeModel.count; ++i) {
                if (i == index) {
                    routes.itemAt(i).state = newState
                }   else {
                    routes.itemAt(i).state = ""
                }
            }
        }


        // background color
        Rectangle {
            anchors.fill: parent
            opacity: rowOpacity  // odd rows
            z:-1
            color: Theme.primaryColor
            radius: 5
            smooth: true
        }

        // define the settings for minimized BackgroundItem
        states: [
            State {
                name: "detailed"
                // all the changes are defined in the transitions
            }
        ]

        transitions: [

            // to Detailed view
            Transition {
                from: ""
                to: "detailed"
                ParallelAnimation {
                    NumberAnimation { target: routeBackground; property: "height"; duration: 300; to: routeHeader.height + detailedView.height}
                    SequentialAnimation {
                        PropertyAnimation { target: detailedView; property: "opacity"; to: 0}
                        FadeAnimation { target: minimizedView; property: "opacity"; duration: 150; to: 0}
                        ScriptAction {script: detailedView.visible = true; }
                        ScriptAction {script: minimizedView.visible = false;  }
                        FadeAnimation { target: detailedView; property: "opacity"; duration: 150; to: 1}
                    }

                }
            },
            // to Minimized view
            Transition {
                from: "detailed"
                to: ""
                ParallelAnimation {
                    NumberAnimation { target: routeBackground; property: "height"; duration: 300; to: routeHeader.height + minimizedView.height}
                    SequentialAnimation {
                        PropertyAnimation { target: minimizedView; property: "opacity"; to: 0}
                        FadeAnimation { target: detailedView; property: "opacity"; duration: 150; to: 0}
                        ScriptAction {script: minimizedView.visible = true;  }
                        ScriptAction {script: detailedView.visible = false; }
                        FadeAnimation { target: minimizedView; property: "opacity"; duration: 150; to: 1}
                    }
                }
            }

        ]

        // Actual route view
        Column {
            id: routeList
            width: parent.width - Theme.paddingSmall


            //// Route header row
            Row {
                width: parent.width
                id: routeHeader

                // Start time
                Label {
                    id: routeStartTime
                    text: JS.prettyTime(RouteStartTime)
                    color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                    width: parent.width / 4
                    font.pixelSize: Theme.fontSizeLarge
                }

                // Icon and start time for the first actual line
                Item {
                    width: parent.width / 4
                    height: routeStartTime.height
                    anchors.verticalCenter:  parent.verticalCenter

                    Elements.LineIcon {
                        id: lineIcon
                        size: 24
                        type: HSL.transportIcon(FirstLineType)
                        anchors.verticalCenter:  parent.verticalCenter
                    }

                    Label {
                        id: firstLineStartTime
                        text: JS.prettyTime(FirstLineStartTime)
                        color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                        anchors.verticalCenter:  parent.verticalCenter
                        anchors.left: lineIcon.right
                        font.pixelSize: Theme.fontSizeSmall
                    }

                }

                // Total travel time
                Label {
                    id: duration
                    text: (Duration/60) + " min"
                    color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                    width: parent.width / 4
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Theme.fontSizeSmall
                }


                // Arrival time
                Label {
                    id: routeEndTime
                    text: JS.prettyTime(RouteEndTime)
                    color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                    width: parent.width / 4
                    font.pixelSize: Theme.fontSizeLarge
                    horizontalAlignment: Text.AlignRight
                }

            }


            // minimized route view
            RouteMinimized {
                id: minimizedView
                width: parent.width
            }

            // detailed route view
            Column {
                id: detailedView
                width: parent.width
                visible: false
                Repeater {
                    model: Legs
                    delegate:
                        // the detailed view
                        LegRow {
                        lineColor: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                        startName: StartName
                        startTime: StartTime
                        endTime: EndTime
                    }
                }
            }
        }
    }

}
