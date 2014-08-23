import QtQuick 2.0
import QtQuick.XmlListModel 2.0


// Create model for waypoints of this leg (select route and leg using index)
XmlListModel {
    property int routeIndex
    property int legIndex
    property ListModel targetListModel
    property string legType

    id: xmlModel

    // only select starting point and endpoint for walking
    query: (legType == "walk" ?
                "/response/node[" + (routeIndex + 1) +"]/node/legs/node[" + (legIndex+1) + "]/locs/node[position()=1 or position() = last()]"
              :
                "/response/node[" + (routeIndex + 1) +"]/node/legs/node[" + (legIndex+1) + "]/locs/node"
            )

    XmlRole { name: "Name"; query: "name/string()" }
    XmlRole { name: "ArrTime"; query: "arrTime/string()" }
    XmlRole { name: "DepTime"; query: "depTime/string()" }
    XmlRole { name: "CoordX"; query: "coord/x/string()" }
    XmlRole { name: "CoordY"; query: "coord/y/string()" }


    onStatusChanged: {

        if (status == XmlListModel.Ready) {
            targetListModel.clear()


            for (var i = 0; i < xmlModel.count ; i++) {
                var waypoint = xmlModel.get(i)

                // add here if data needs changing
                waypoint.WaypointIndex = i
                waypoint.WaypointLegIndex = legIndex


                if (waypoint.Name == "") {
                    if (i == 0) {
                        waypoint.Name = sourceName
                    } else {
                        waypoint.Name = destinationName
                    }
                }

                targetListModel.append(waypoint)
            }
            // reimplement this
            //targetListModel.newDataLoaded()
        }
    }
}
