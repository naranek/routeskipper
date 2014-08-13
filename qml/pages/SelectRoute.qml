import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "../js/HSL-functions.js" as HSL
import "../elements" as Elements
import "../models" as Models
import "../js/Common.js" as JS

Page {
    id: mainPage


    // remove legs and waypoints selected on the next page
    onStatusChanged: {
        if (status == PageStatus.Active) {
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
            HSL.makeHttpRoutingRequest()
        }

        if (httpQueryStatus == 2) httpQueryFailed = false
    }

    property int lastClickedRouteSummary: -1

    property ApplicationWindow mainWindow // maintain connection with mainWindow to connect to cover


    Component.onCompleted: {
        // fetch the first XML from HSL - result is placed in hslXml variable when finished
        HSL.makeHttpRoutingRequest()
    }

    Models.HslRoutesXmlList {
        xml: hslXml
        targetListModel: routeModel
    }

    ListModel {
        id: routeModel
    }

    Models.Credentials {
        id: credentials
    }



    // Busy indicator and error text. These are dwarn according to httpQueryStatus and httpQueryFailed
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
        text: qsTr("Haku epäonnistui. Yritetään uudestaan.")

    }


    SilicaFlickable {
        anchors.fill: parent

        contentHeight: mainColumn.height + Theme.paddingLarge

        contentWidth: parent.width

        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("Uusi haku")
                onClicked: pageStack.pop(null)
            }
            MenuItem {
                text: qsTr("Seuraavat yhteydet")
                onClicked: {
                    var lastTime = routeModel.get(routeModel.count-1).RouteStartTime
                    selectedTime = JS.hslTime(lastTime)
                    selectedDate = JS.hslDate(lastTime)
                    HSL.makeHttpRoutingRequest()
                }
            }
            MenuItem {
                text: qsTr("Lähtöaika: Nyt")
                onClicked: {
                    selectedTime = Qt.formatDateTime(new Date(), "hhmm")
                    selectedDate = Qt.formatDateTime(new Date(), "yyyyMMdd")
                    HSL.makeHttpRoutingRequest()
                }
            }
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
            width: parent.width - 2* Theme.paddingLarge
            x: Theme.paddingLarge
            y: Theme.paddingLarge



            // show the selected routes
            Elements.SelectedRoutesSummary {
                sourceName: mainPage.sourceName
                sourceTime: mainPage.selectedTime
                destinationName: mainPage.destinationName

            }



            // Show routes summary
            // Can't use SilicaListView, because delegate states can't be changed then
            Repeater {
                id: routes
                model: routeModel


                delegate: BackgroundItem {
                    id: routeBackground
                    height: contentItem.childrenRect.height
                    anchors.bottomMargin: 30
                    clip: true // clipping on, so that route details are hidden when minimized


                    Models.HslLegsXmlList {
                        xml: hslXml
                        routeIndex: index
                        targetListModel: legsModel
                    }
                    ListModel {
                        id: legsModel
                    }


                    // add a sliding transition because we can
                    transitions: Transition {
                        PropertyAnimation { properties: "height"; duration: 200 }
                    }


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
                            newState = "minimized"
                            routeDetails.show(index)
                            lastClickedRouteSummary = index

                            // Add new legs to selectedLegsModel
                            mainWindow.selectedLegsModel.removeLegsFromPage(pageStack.depth) // remove this level's old selection
                            mainWindow.selectedLegsModel.addLegs(legsModel, pageStack.depth) // add new selection
                            mainWindow.coverPage.resetCover()
                        }

                        // minimize all other items except the one clicked
                        for (var i = 0; i < routeModel.count; ++i) {
                            if (i == index) {
                                routes.itemAt(i).state = ""
                            }   else {
                                routes.itemAt(i).state = newState
                            }
                        }

                    }

                    // define the settings for minimized BackgroundItem
                    states: [
                        State {
                            name: "minimized"
                            PropertyChanges {
                                target: routeBackground
                                height: routeHeader.height + divider.height
                            }
                        }
                    ]


                    // Actual route view
                    Column {
                        id: routeList
                        width: parent.width

                        GlassItem {
                            id: divider
                            objectName: "menuitem"
                            height: Theme.paddingMedium
                            width: mainPage.width
                            falloffRadius: 0.150
                            radius: 0.150
                            color: Theme.highlightColor
                            cache: false
                        }

                        Label {
                            id: routeHeader
                            text: (index +1) +": " + JS.prettyTime(RouteStartTime) + " - " + JS.prettyTime(RouteEndTime) + " (" + (Duration/60) + " min, " +
                                  qsTr("kävelyä") + " " + JS.formatLength(WalkingLength) + ")"
                            color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor

                        }


                        Repeater {
                            id: legsRepeater
                            model: legsModel
                            clip: true

                            delegate:
                                Elements.LegRow {
                                lineColor: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                                startName: StartName
                                startTime: StartTime
                                endTime: EndTime
                            }

                        }
                    }
                }

            }



            Elements.RouteDetails{
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
