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


                    // the opacity that changes depending on if it's even or odd row
                    property real rowOpacity: 0.15 - (index % 2) *0.1

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
                            newState = "detailed"
                            routeDetails.show(index)
                            lastClickedRouteSummary = index

                            // Add new legs to selectedLegsModel
                            mainWindow.selectedLegsModel.removeLegsFromPage(pageStack.depth) // remove this level's old selection
                            mainWindow.selectedLegsModel.addLegs(legsModel, pageStack.depth) // add new selection
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
                            PropertyChanges {
                                target: routeBackground
                                height: routeHeader.height + divider.height
                            }
                            PropertyChanges {
                                target: minimizedView
                                visible: false
                            }
                            PropertyChanges {
                                target: detailedView
                                visible: true

                            }
                        }
                    ]


                    // Actual route view
                    Column {
                        id: routeList
                        width: parent.width - Theme.paddingSmall


                        // Route header row
                        Row {
                            width: parent.width
                            id: routeHeader

                            Label {
                                id: startTime
                                text: JS.prettyTime(RouteStartTime)
                                color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                                width: parent.width / 3
                                font.pixelSize: Theme.fontSizeLarge
                            }

                            Label {
                                id: duration
                                text: (Duration/60) + " min"
                                color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                                width: parent.width / 3
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignHCenter
                            }


                            Label {
                                id: endTime
                                text: JS.prettyTime(RouteEndTime)
                                color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                                width: parent.width / 3
                                font.pixelSize: Theme.fontSizeLarge
                                horizontalAlignment: Text.AlignRight
                            }

                        }

                        // minimized view
                        Item {
                            id: minimizedView
                            width: parent.width
                            height: lineRow.height
                            Row {
                                id: lineRow
                                width: parent.width - walkIcon.width - walkingLength.width
                                Repeater {
                                    id: legsRepeater
                                    model: legsModel
                                    clip: true

                                    delegate:

                                        Elements.LineShield {id: lineShield; visible: Type !== "walk" && Type !== "wait" ? true : false; lineColor: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor; state: "horizontal"}



                                }
                            }

                            Image {
                                id: walkIcon
                                width: 32; height: 32
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                source: "qrc:icon-walk"
                                anchors.left: lineRow.right
                                anchors.top: parent.top
                            }

                            Label {
                                id: walkingLength
                                text: JS.formatLength(WalkingLength)
                                color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                                width: 90
                                horizontalAlignment: Text.AlignRight
                                anchors.left: walkIcon.right
                                anchors.top: parent.top
                            }

                            Image {
                                id: waitIcon
                                width: 32; height: 32
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                source: "qrc:icon-wait"
                                anchors.left: lineRow.right
                                anchors.bottom: parent.bottom
                            }

                            Label {
                                id: waitDuration
                                text: Math.round((Duration - MovingDuration)/60) + " min"
                                color: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                                width: 90
                                horizontalAlignment: Text.AlignRight
                                anchors.left: walkIcon.right
                                anchors.bottom: parent.bottom
                            }
                        }


                        // the detailed view
                        Elements.LegRow {
                            id: detailedView
                            lineColor: routeBackground.highlighted ? Theme.highlightColor : Theme.primaryColor
                            startName: StartName
                            startTime: StartTime
                            endTime: EndTime
                            visible: false
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
