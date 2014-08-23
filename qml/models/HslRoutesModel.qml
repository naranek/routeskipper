import QtQuick 2.0
import QtQuick.XmlListModel 2.0
// route model
ListModel {
    id: routesModel
    property string xml

    onXmlChanged:  {
        var routeComponent = Qt.createComponent("../models/HslRoutesXmlList.qml");

        if (routeComponent.status == Component.Ready)
            routeComponent.createObject(routeModel, {targetListModel: routesModel, xml: routesModel.xml,});
    }
}
