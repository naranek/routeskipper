import QtQuick 2.0
import QtQuick.XmlListModel 2.0

// legs model
ListModel {
    id: legsModel
    property int routeIndex
    property string xml

   // onDestroyed: console.log("Shiiiit! LedModel destroyed!")

    onXmlChanged:  {
        var legsComponent = Qt.createComponent("HslLegsXmlList.qml");

        if (legsComponent.status == Component.Ready)
            legsComponent.createObject(legsModel, {targetListModel: legsModel, routeIndex: legsModel.routeIndex, xml: legsModel.xml});



    }
}
