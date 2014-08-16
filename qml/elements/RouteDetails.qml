import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "../js/HSL-functions.js" as HSL
import "../elements" as Elements
import "../models" as Models
import "../js/Common.js" as JS



// Show single route details
Column {
    id: routeDetailsColumn
    spacing: 0
    width: parent.width


    property int routeIndex
    property int newRouteIndex

    // clear waypoints if the selected route is changed
    onRouteIndexChanged: {
        mainWindow.selectedWaypointsModel.removeWaypointsFromPage(pageStack.depth) // remove this level's old selection
    }

    // create signals for status change
    // show also needs XML data and index of the route to use
    signal show(string newRouteIndex)
    onShow: {
        routeDetailsColumn.newRouteIndex = newRouteIndex

        // two states, because we want to run the visible animation every time, and it doesn't trigger
        // if state is visible -> visible
        routeDetailsColumn.state= "change"
        routeDetailsColumn.state= "visible"
    }

    signal hide
    onHide: {
        routeDetailsColumn.state= ""
    }


    // default is hidden
    opacity: 0


    transitions: [
        Transition {
            from: "change"
            to: "visible"
            SequentialAnimation {
                // this is a slow operation, so wait until the other animations have finished before starting
                PropertyAction { target: routeDetailsColumn; property: "visible"; value: false }
                PauseAnimation { duration: 750 }
                PropertyAction { target: routeDetailsColumn; property: "routeIndex"; value: newRouteIndex }
                PauseAnimation { duration: 1000 }
                PropertyAction { target: routeDetailsColumn; property: "visible"; value: true }

                //NumberAnimation { target: routeDetailsColumn ; property: "opacity"; to: 0; duration: 200; }

                //
                //NumberAnimation { target: routeDetailsColumn ; property: "opacity"; to: 1; duration: 200; }
            }
        },
        Transition {
            from: "visible"
            to: ""
            SequentialAnimation {
                //PauseAnimation { duration: 1000 }
                //NumberAnimation { target: routeDetailsColumn ; property: "opacity"; to: 0; duration: 200; }
                PropertyAction { target: routeDetailsColumn; property: "visible"; value: false }
            }
        }
    ]


    // define the settings for minimized BackgroundItem
    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: routeDetailsColumn
                opacity: 1
            }
        },
        State {
            name: "change"
        }
    ]


    Models.HslLegsXmlList {
        xml: hslXml
        routeIndex: routeDetailsColumn.routeIndex
        targetListModel: legsModel
    }
    ListModel {
        id: legsModel
    }

    SectionHeader {
        text: qsTr("Stop information")
    }

    Repeater {
        id: legsRepeater
        model: legsModel

        delegate:
            Column {

            id: legColumn
            width: routeDetailsColumn.width
            spacing: 0

            Row {
                Elements.LineShield {
                    id: lineShield
                    lineColor: Theme.highlightColor
                }
            }

            // Create model for waypoints of this route (select route using index)
            Models.HslWaypointsXmlList {
                xml: hslXml
                targetListModel: waypointModel
                routeIndex: routeDetailsColumn.routeIndex
                legIndex: LegIndex
            }

            ListModel {
                id: waypointModel
                signal newDataLoaded

                // add new selection to selectedWaypoint
                onNewDataLoaded: {
                    mainWindow.selectedWaypointsModel.addWaypoints(waypointModel, pageStack.depth)
                }
            }

            Repeater {
                id: waypointRepeater

                // store index in property so we can refer to it from another Repeater
                property int legIndex: LegIndex

                model: waypointModel

                delegate: BackgroundItem {
                    id: waypointBox
                    height: waypointRow.height + 20

                    ListModel {id: returnData }

                    onClicked: {
                        //the new way
                        mainWindow.selectedWaypointsModel.stopAtWaypoint(pageStack.depth, waypointRepeater.legIndex, index) // remove this level's old selection
                        mainWindow.selectedLegsModel.changeEndpoint(pageStack.depth, waypointRepeater.legIndex, model)

                        // return the clicked waypoint model
                        routeDetailsColumn.waypointClicked(model)

                    }

                    Row {
                        id: waypointRow
                        spacing: 0
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            text: (index == 0 ? JS.prettyTime(DepTime) : JS.prettyTime(ArrTime)) // HSL shows depTime > arrTime if there is waiting on the bus stop
                            font.pixelSize: Theme.fontSizeSmall
                            width: 100
                            anchors.verticalCenter: parent.verticalCenter

                        }
                        Label {
                            text: Name
                            font.pixelSize: Theme.fontSizeSmall
                            width: 300
                            anchors.verticalCenter: parent.verticalCenter
                            truncationMode: TruncationMode.Fade
                        }
                        Label {
                            text: HSL.makeLineCode(JORECode)
                            font.pixelSize: Theme.fontSizeSmall
                            width: 100
                        }
                    }
                }

            }
        }
    }
}
