import QtQuick 2.0
import QtQuick.XmlListModel 2.0


XmlListModel {
    property string arrTime
    property string routeCode

    // get the lineID for the bus that's driving the route
    // do the matching by matching scheduled arrival time and route code

    query: "//*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='getNextDeparturesResponse']/*[local-name()='result']" +
           "*[local-name()='item'][*[local-name()='time'] = '" + arrTime + "' and *[local-name()='route'] = '" + routeCode + "']"

    XmlRole { name: "LineId"; query: "id/string()" }

}
