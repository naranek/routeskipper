import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "pages"
import "models" as Models

ApplicationWindow
{
    id: mainWindow
    initialPage: Component { FirstPage { } }

    property alias selectedLegsModel: selectedLegsModel
    property alias selectedWaypointsModel: selectedWaypointsModel
    property alias coverPage: coverPage

    cover:
        CoverPage {
            id: coverPage
        }

    Models.SelectedLegs {
        id: selectedLegsModel

    }



    Models.SelectedWaypoints {
        id: selectedWaypointsModel
    }


    Models.KamoLineId {
        id: kamoLineIdModel
    }
}


