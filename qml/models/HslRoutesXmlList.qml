import QtQuick 2.0
import QtQuick.XmlListModel 2.0


// This model will only handle the route level separation
// Another model is used to get all the legs for a single route
XmlListModel {
    id: xmlModel

    property ListModel targetListModel

    // Get the XML response from reittiopas
    // We can't use source property for XmlListModel, because we need to
    // create two models from the same data, and that would fetch the data
    // two times

    query: "/response/node/node"

    XmlRole { name: "Length"; query: "length/string()" }
    XmlRole { name: "Duration"; query: "duration/string()" }
    XmlRole { name: "RouteStartTime"; query: "legs/node[1]/locs/node[1]/depTime/string()" }
    XmlRole { name: "RouteEndTime"; query: "legs/node[last()]/locs/node[last()]/arrTime/string()" }
    XmlRole { name: "WalkingLength"; query: "sum(legs/node[type='walk']/length)" }



    onStatusChanged: {

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
                targetListModel.clear()

                for (var i = 0; i < xmlModel.count ; i++) {
                    var route = xmlModel.get(i)
                    // add here if route needs changing
                    targetListModel.append(route)
                }
            }
        }
    }
}
