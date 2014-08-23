import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/DatabaseTools.js" as DbTools
import "../js/Common.js" as JS
import "../js/HSL-functions.js" as HSL

Page {
    property ListModel routeModel
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: mainColumn.height

        Column  {
            id: mainColumn
            Repeater {
                model: routeModel
                delegate: Column {
                    Label {
                        text: "Route " + index + ": " + JS.prettyTime(RouteStartTime) + " - " + JS.prettyTime(RouteEndTime)
                    }


                    Repeater {
                        model: Legs
                        delegate: Column {
                            Label {
                                text: "Leg " + index + ": " + Type + "(" + HSL.makeLineCode(JORECode) + ") " + JS.prettyTime(StartTime) + " - " + JS.prettyTime(EndTime)
                            }

                            Repeater {
                                model: Waypoints
                                delegate: Column {
                                    Label {
                                        text: "Waypoint " + index + ": " + Name
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
