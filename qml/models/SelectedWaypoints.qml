import QtQuick 2.0

ListModel {
    id: selectedWaypoints

    // add new Waypoints and waypoints to the common selected Waypoints model
    signal addWaypoints(ListModel WaypointsModel, int currentPage)
    onAddWaypoints: {
        for (var i = 0; i < WaypointsModel.count; ++i) {
            //            console.log("Ennen lisäystä: " + selectedWaypoints.count)
            var waypoint = WaypointsModel.get(i)
            waypoint.CurrentPage = currentPage

            selectedWaypoints.append(waypoint)
        }
    }

    // delete Waypoints which have higher or the same currentPage as in parameter
    signal removeWaypointsFromPage(int currentPage)
    onRemoveWaypointsFromPage: {
        //        console.log("Ennen poistoa: " + selectedWaypoints.count)
        for (var i = selectedWaypoints.count-1; i >=0 ; i--) {
            if (selectedWaypoints.get(i).CurrentPage >= currentPage) {
                selectedWaypoints.remove(i)
            }
        }
    }

    // delete Waypoints which have the same currentPage and higher WaypointIndex as in parameter
    signal stopAtWaypoint(int depth, int legIndex, int waypointIndex)
    onStopAtWaypoint: {
//        console.log("depth: " + depth + " ja wpInd: " + waypointIndex + " ja leg: " + legIndex)
//        console.log("Ennen poistoa: " + selectedWaypoints.count)


        for (var i = selectedWaypoints.count-1; i >=0 ; i--) {
//            console.log("Valittu depth: " + selectedWaypoints.get(i).CurrentPage + " ja wpInd " + selectedWaypoints.get(i).WaypointIndex + " ja legIndex " + selectedWaypoints.get(i).LegIndex)

            // delete waypoints after the selected one
            if (selectedWaypoints.get(i).CurrentPage == depth && selectedWaypoints.get(i).WaypointLegIndex == legIndex && selectedWaypoints.get(i).WaypointIndex > waypointIndex ) {
//                console.log("Poistettiin: " + selectedWaypoints.get(i).Name)
                selectedWaypoints.remove(i)
            }


        }

        // delete waypoints from all legs after the selected one
        for (var i = selectedWaypoints.count-1; i >=0 ; i--) {
//            console.log("Valittu depth: " + selectedWaypoints.get(i).CurrentPage + " ja wpInd " + selectedWaypoints.get(i).WaypointIndex + " ja legIndex " + selectedWaypoints.get(i).LegIndex)
            if (selectedWaypoints.get(i).CurrentPage == depth && selectedWaypoints.get(i).WaypointLegIndex > legIndex ) {
//                console.log("Poistettiin myös: " + selectedWaypoints.get(i).Name)
                selectedWaypoints.remove(i)
            }
        }
    }
}
