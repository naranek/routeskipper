import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "../js/HSL-functions.js" as HSL
import "../js/Common.js" as JS
import "../js/KAMO-functions.js" as KAMO
import "../elements" as Elements
import "../models" as Models
import "selectRoute" as PageElements

Page {
    id: mainPage



    onStatusChanged: {
        if (status === PageStatus.Active) {
            // remove legs and waypoints selected on the next page
            mainWindow.selectedLegsModel.removeLegsFromPage(pageStack.depth + 1)
            mainWindow.selectedWaypointsModel.removeWaypointsFromPage(pageStack.depth + 1)

        }
    }

    // properties for receiving parameters from previous page
    property string sourceName
    property string destinationName
    property string sourceCoords
    property string destinationCoords
    property string selectedTime
    property string selectedDate
    property string timeType: "departure"

    // get the route as a default value for now
    property string hslXml


    // The status of the http query (0=not started, 1=started, 2=finished, -1=error)
    property int httpQueryStatus: 0
    property bool httpQueryFailed: false

    // retry if the fetch failed
    onHttpQueryStatusChanged: {
        if (httpQueryStatus == -1) {
            httpQueryStatus = 0
            httpQueryFailed = true
            HSL.makeHttpRoutingRequest(-5)
        }

        if (httpQueryStatus == 2) httpQueryFailed = false
    }

    property int lastClickedRouteSummary: -1

    property ApplicationWindow mainWindow // maintain connection with mainWindow to connect to cover


    Component.onCompleted: {
        // fetch the first XML from HSL - result is placed in hslXml variable when finished
        HSL.makeHttpRoutingRequest(-5)
    }



    // route model
    Models.HslRoutesModel {
        id: routeModel
        xml: hslXml
    }

    Models.Credentials {
        id: credentials
    }

    // timer that keeps the realtime data real
    Timer {
        id: kamoTimer
        interval: 1000 * 120 // once in 2 minutes
        running: Qt.application.active == true
        repeat: true
        onTriggered: {
            console.log("updating realtime data")
            // get realtime data for all the legs in the current search results
            for (var i = 0; i < routeModel.count; i++) {
                for (var j = 0; j < routeModel.get(i).Legs.count; j++) {
                    KAMO.mergeRealtimeData(routeModel.get(i).Legs.get(j), 110)
                }
            }
        }
    }


    // Busy indicator and error text. These are drawn according to httpQueryStatus and httpQueryFailed
    BusyIndicator  {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: httpQueryStatus < 2
    }

    Label {
        anchors {
            horizontalCenter: busyIndicator.horizontalCenter
            top: busyIndicator.bottom
        }
        visible: httpQueryFailed == true
        text: qsTr("Query failed. Fine. I'll try again.")

    }


    // graphical content
    SilicaFlickable {
        anchors.fill: parent

        contentHeight: mainColumn.height + Theme.paddingLarge

        contentWidth: parent.width

        VerticalScrollDecorator {}

        PullDownMenu {

            MenuItem {
                text: qsTr("Previous connections")
                onClicked: {
                    var lastTime = routeModel.get(0).RouteEndTime
                    timeType="arrival"
                    selectedTime = JS.hslTime(lastTime)
                    selectedDate = JS.hslDate(lastTime)
                    HSL.makeHttpRoutingRequest(-1)
                }
            }


            MenuItem {
                text: qsTr("Departure: Now")
                onClicked: {
                    timeType = "departure"
                    selectedTime =JS.hslTime(new Date())
                    selectedDate = JS.hslDate(new Date())
                    HSL.makeHttpRoutingRequest(-5)
                }
            }

            MenuItem {
                text: qsTr("Next connections")
                onClicked: {
                    var lastTime = routeModel.get(routeModel.count-1).RouteStartTime
                    timeType="departure"
                    selectedTime = JS.hslTime(lastTime)
                    selectedDate = JS.hslDate(lastTime)
                    HSL.makeHttpRoutingRequest(1)
                }
            }

/*
            MenuItem {
                text: qsTr("Model validator")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("RouteModelValidator.qml"), {routeModel: routeModel})
                }
            }
*/
        }

        // Show the clock
        Elements.Clock {
            running: Qt.application.active == true // clock is ticking only when the application is active
            width: parent.width /3.5
            height: 60
            font.pixelSize: Theme.fontSizeLarge

            anchors {
                top: parent.top
                topMargin: - 5
                horizontalCenter: parent.horizontalCenter
            }
        }


        // Main column holds everything else and sets margins
        Column{
            id: mainColumn
            spacing: 2
            width: parent.width
            y: Theme.paddingLarge



            // show the selected routes
            PageElements.SelectedRoutesSummary {
                sourceName: mainPage.sourceName
                sourceTime: mainPage.selectedTime
                destinationName: mainPage.destinationName
                x: Theme.paddingLarge
            }



            // show the route summary
            PageElements.RoutesSummary {
                id: routes
            }

            // show the selected route and populate selectedWaypointsModel
            PageElements.CurrentRouteDetails{
                id: routeDetails



                signal waypointClicked(variant waypoint)

                onWaypointClicked: {
                    // call another page to get refined routing

                    pageStack.push(Qt.resolvedUrl("SelectRoute.qml"),
                                   {sourceName: waypoint.Name,
                                       destinationName: destinationName,
                                       sourceCoords: waypoint.CoordX + "," + waypoint.CoordY,
                                       destinationCoords: destinationCoords,
                                       selectedTime: JS.hslTime(waypoint.ArrTime),
                                       selectedDate: JS.hslDate(waypoint.ArrTime),
                                       mainWindow: mainWindow
                                   } )
                }
            }


        }
    }
}
