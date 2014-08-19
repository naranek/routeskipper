import QtQuick 2.0
import QtQuick.XmlListModel 2.0


XmlListModel {
    query: "//*[local-name()='Envelope']/*[local-name()='Body']/*[local-name()='getPassingTimesResponse']/*[local-name()='result']/*[local-name()='item']"

    XmlRole { name: "Id"; query: "id/string()" }
    XmlRole { name: "Stop"; query: "stop/string()" }
    XmlRole { name: "Line"; query: "line/string()" }
    XmlRole { name: "Time"; query: "time/string()" }
    XmlRole { name: "Rtime"; query: "rtime/string()" }


}
