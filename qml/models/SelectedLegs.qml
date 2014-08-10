import QtQuick 2.0

ListModel {
    id: selectedLegs


    // add new legs and waypoints to the common selected legs model
    signal addLegs(ListModel legsModel, int currentPage)
    onAddLegs: {
        for (var i = 0; i < legsModel.count; ++i) {
            var leg = legsModel.get(i)
            leg.CurrentPage = currentPage

            selectedLegs.append(leg)
        }
    }

    // delete legs which have higher or the same currentPage as in parameter
    signal removeLegsFromPage(int currentPage)
    onRemoveLegsFromPage: {
        for (var i = selectedLegs.count-1; i >=0 ; i--) {
            if (selectedLegs.get(i).CurrentPage >= currentPage) {
                selectedLegs.remove(i)
            }
        }
    }

    // change the current leg's endpoint
    signal changeEndpoint(int depth, int legIndex, variant waypoint)
    onChangeEndpoint: {
        for (var i = selectedLegs.count-1; i >=0 ; i--) {
            // change the selected leg's endpoint
            if (selectedLegs.get(i).CurrentPage == depth && selectedLegs.get(i).LegIndex == legIndex) {
                selectedLegs.get(i).EndName = waypoint.Name
                selectedLegs.get(i).EndTime = waypoint.ArrTime

                // remove all legs after that
                for (var j = selectedLegs.count-1; j > i; j--) {
                    selectedLegs.remove(j)
                }

            }

        }
    }
}
