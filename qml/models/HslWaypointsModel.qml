import QtQuick 2.0
import QtQuick.XmlListModel 2.0

// waypoints model
ListModel {
    id: waypointsModel
    property string xml
    property int routeIndex
    property int legIndex
    property string legType

    onXmlChanged:  {
        var waypointsComponent = Qt.createComponent("../models/HslWaypointsXmlList.qml");

        if (waypointsComponent.status == Component.Ready)
            waypointsComponent.createObject(waypointsModel, {targetListModel: waypointsModel,
                                                routeIndex: waypointsModel.routeIndex, legIndex: waypointsModel.legIndex,
                                                legType: waypointsModel.legType,
                                                xml: waypointsModel.xml,});

    }
}
