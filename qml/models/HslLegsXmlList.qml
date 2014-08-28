import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import "../js/Common.js" as JS

// Create model for legs of this route (select route using index)
XmlListModel {
    property int routeIndex
    property ListModel targetListModel

    id: xmlModel
    xml: hslXml
    query: "/response/node[" + (routeIndex + 1) +"]/node/legs/node"

    XmlRole { name: "Type"; query: "type/string()" }
    XmlRole { name: "Duration"; query: "duration/string()" }
    XmlRole { name: "Length"; query: "length/string()" }
    XmlRole { name: "JORECode"; query: "code/string()" }
    XmlRole { name: "StartName"; query: "locs/node[1]/name/string()" }
    XmlRole { name: "StartTime"; query: "locs/node[1]/depTime/string()" }
    XmlRole { name: "StartCode"; query: "locs/node[1]/code/string()" }      // Code of the first stop - used with KAMO
    XmlRole { name: "EndName"; query: "locs/node[last()]/name/string()" }
    XmlRole { name: "EndTime"; query: "locs/node[last()]/arrTime/string()" }
    XmlRole { name: "EndCode"; query: "locs/node[last()]/code/string()" }
    XmlRole { name: "EndDepTime"; query: "locs/node[last()]/depTime/string()" }
    XmlRole { name: "StartX"; query: "locs/node[1]/coord/x/string()" }
    XmlRole { name: "StartY"; query: "locs/node[1]/coord/y/string()" }
    XmlRole { name: "EndX"; query: "locs/node[last()]/coord/x/string()" }
    XmlRole { name: "EndY"; query: "locs/node[last()]/coord/y/string()" }



    onStatusChanged: {
        if (status == XmlListModel.Ready) {
            targetListModel.clear()

            var waypointsComponent = Qt.createComponent("HslWaypointsModel.qml");

            for (var i = 0; i < xmlModel.count ; i++) {
                var leg = xmlModel.get(i)
                // add here if route needs changing

                // add waypoints
                if (waypointsComponent.status == Component.Ready)
                    leg.Waypoints = waypointsComponent.createObject(xmlModel, {routeIndex: xmlModel.routeIndex,
                                                                        legIndex: i, legType: leg.Type,
                                                                        xml: xmlModel.xml,});


                // StartName and EndName are empty for first and last node.
                // we'll use the search terms for them
                if (leg.StartName == "") leg.StartName = sourceName
                if (leg.EndName == "") leg.EndName = destinationName

                // the number of the leg on the route
                leg.LegIndex = i

                // the page depth the leg was searched
                leg.PageId = currentPage

                // For Kamo realtime data:
                leg.LineId = ""
                leg.RealStartTime = ""
                leg.RealEndTime = ""
                leg.RealUpdateTime = new Date(0) // updated a long ago

                // add leg to model
                targetListModel.append(leg)

                // add waiting as a separate leg
                if (leg.EndTime < leg.EndDepTime) {
                    var waitingLeg = xmlModel.get(i)
                    waitingLeg.Type = "wait"
                    waitingLeg.Duration = JS.timestampDifferenceInSeconds(leg.EndTime, leg.EndDepTime).toString()
                    waitingLeg.Length = "0"
                    waitingLeg.JORECode = ""

                    waitingLeg.StartX = leg.EndX
                    waitingLeg.StartY = leg.EndY
                    waitingLeg.StartTime = ""
                    waitingLeg.EndTime = ""
                    waitingLeg.StartName = ""

                    waitingLeg.RealStartTime = ""
                    waitingLeg.RealEndTime = ""
                    waitingLeg.LegIndex = -1

                    targetListModel.append(waitingLeg)
                }
            }


        }
    }

}
