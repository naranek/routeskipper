import QtQuick 2.0
import QtQuick.XmlListModel 2.0


// This model will only handle the route level separation
// Another model is used to get all the legs for a single route
XmlListModel {
    id: xmlModel

    property ListModel targetListModel

    query: "/response/node/node"

    XmlRole { name: "Length"; query: "length/string()" }
    XmlRole { name: "Duration"; query: "duration/string()" }
    XmlRole { name: "RouteStartTime"; query: "legs/node[1]/locs/node[1]/depTime/string()" }
    XmlRole { name: "RouteEndTime"; query: "legs/node[last()]/locs/node[last()]/arrTime/string()" }

    XmlRole { name: "FirstLineStartTime"; query: "(legs/node[type!='walk'])[1]/locs/node[1]/depTime/string()" } // start time of the first leg that's not walking
    XmlRole { name: "FirstLineType"; query: "(legs/node[type!='walk'])[1]/type/string()" } // transport type of the first leg that's not walking


    XmlRole { name: "WalkingLength"; query: "sum(legs/node[type='walk']/length)" }
    XmlRole { name: "MovingDuration"; query: "sum(legs/node/duration)" } // time spent moving. Duration - MovingDuration = waiting time



    onStatusChanged: {
        // if connection failed
        if (status == XmlListModel.Error) {
            httpQueryFailed = true
            httpQueryStatus = -1
        }

        if (status == XmlListModel.Ready) {
            // if xml parsing fails, the status will be OK, but count 0 - bug?
            // so anyway - we retry
            if (xmlModel.count == 0) {
                httpQueryFailed = true
                httpQueryStatus = -1
            }
            else {
                // Add routes to the target model
                targetListModel.clear()

                var routeIndex = -1

                for (var i = 0; i < xmlModel.count ; i++) {
                    // if timeType = arrival, the route order is reversed. Damn. We'll reverse it again
                    if (timeType === "arrival") {
                        routeIndex = xmlModel.count - i - 1
                    }
                    else {
                        routeIndex = i
                    }

                    var route = xmlModel.get(routeIndex)

                    var legsComponent = Qt.createComponent("HslLegsModel.qml");


                    // add here if route needs changing

                    // for Kamo
                    route.FirstLineRealStartTime = ""

                    if (legsComponent.status == Component.Ready)
                        route.Legs = legsComponent.createObject(null, {routeIndex: routeIndex, xml: xmlModel.xml});




                    targetListModel.append(route)
                }
            }


        }
    }
}
