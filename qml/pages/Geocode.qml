import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "../js/DatabaseTools.js" as DbTools
import "../js/HSL-functions.js" as HSL
import "../models" as Models

Page {
    id: root
    property string searchstring
    property Item parentPage


    BusyIndicator  {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: xmlModel.progress < 1
    }

    Label {
        id: errorText
        anchors {
            horizontalCenter: busyIndicator.horizontalCenter
            top: busyIndicator.bottom
        }
        visible: false
        width: parent.width
        wrapMode: Text.WordWrap
    }

    Models.Credentials {
        id: credentials
    }

    SilicaListView {

        id: listView
        anchors.fill: parent
        model: xmlModel

        header: PageHeader { title: qsTr("Search") + ": " + searchstring}

        // Get the XML response from reittiopas. This is pure awesome and magic combined
        XmlListModel {
            id: xmlModel
            source: "http://api.reittiopas.fi/hsl/prod/?request=geocode&user=" + credentials.hslUsername + "&pass=" + credentials.hslPassword + "&format=xml&disable_unique_stop_names=0&key=" + encodeURI(searchstring)
            query: "/response/node"

            XmlRole { name: "Name"; query: "name/string()" }
            XmlRole { name: "City"; query: "city/string()" }
            XmlRole { name: "Coords"; query: "coords/string()" }
            XmlRole { name: "HouseNumber"; query: "details/houseNumber/string()" }
            XmlRole { name: "LocationTypeId"; query: "locTypeId/string()" }



            onStatusChanged: {
                if (status == XmlListModel.Error) {
                    errorText.visible = true
                    errorText.text = qsTr("Connection to Reittiopas failed")
                }
                if (status == XmlListModel.Ready && xmlModel.count == 0) {
                    errorText.visible = true
                    errorText.text = qsTr("Nothing was found, or connection to Reittiopas failed")
                }
            }
        }


        VerticalScrollDecorator {}

        delegate: ListItem {
            id: listItem

            onClicked: {
                var locationName = Name + " " + HouseNumber
                DbTools.addStop(locationName.trim(), Coords)
                DbTools.incrementUseCounter(locationName.trim(), Coords)
                parentPage.returnSelection(locationName.trim(), Coords)

                // strange, but pop(null) doesn't work here
                pageStack.pop(pageStack.find(function(page) {
                    return page.isFirstPage === true
                }));


            }

            Label {
                text: HSL.locationTypeText(LocationTypeId)
                anchors.bottom: parent.bottom
                font.italic: true
                font.pixelSize: Theme.fontSizeExtraSmall
                x: Theme.paddingLarge
                color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
            }

            Label {
                x: Theme.paddingLarge
                text: Name + (HouseNumber !== "" ? " " + HouseNumber : "") + ", " + City
                anchors.verticalCenter: parent.verticalCenter
                font.capitalization: Font.Capitalize
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
        }
    }

    ListModel {
        id: geocodeResults
    }
}
