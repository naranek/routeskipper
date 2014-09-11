import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import "../js/HSL-functions.js" as HSL

// legs model
ListModel {
    id: legsModel
    property int routeIndex
    property string xml
    property variant routeModel

    onXmlChanged:  {
        var legsComponent = Qt.createComponent("HslLegsXmlList.qml");
        if (legsComponent.status == Component.Ready)
            legsComponent.createObject(legsModel, {targetListModel: legsModel, routeIndex: legsModel.routeIndex, xml: legsModel.xml});
    }
}
