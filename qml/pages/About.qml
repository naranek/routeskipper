import QtQuick 2.0
import Sailfish.Silica 1.0

import "../elements" as Elements

Page {
    id: routePage

    ListModel {
        id: iconLicenses
        ListElement {icon: "logo" }
        ListElement {icon: "bussi" }
        ListElement {icon: "kavely" }
        ListElement {icon: "juna" }
        ListElement {icon: "lautta" }
        ListElement {icon: "juna" }
        ListElement {icon: "odotus" }
        ListElement {icon: "metro" }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height
        width: parent.width

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            spacing: Theme.paddingMedium
            width: parent.width - 2* Theme.paddingLarge
            x: Theme.paddingLarge

            PageHeader {
                title: "About RouteSkipper"
            }

            Label {
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.WordWrap
                text: "RouteSkipper is made by Jarmo Lahtiranta (@naranek) and licensed under GNU GPL v3.0"
                width: parent.width
            }

            PageHeader {
                title: "Icons"
            }

            Label {
                font.pixelSize: Theme.fontSizeExtraSmall
                width: parent.width
                wrapMode: Text.WordWrap
                text: "All icons are made by Lassi Salohalla and distributed under CC BY-NC 4.0 license."
            }

            GridView {
                model: iconLicenses
                width: parent.width
                height: 300

                delegate:

                    Elements.LineIcon {
                    id: image
                    size: 48
                    type: icon
                }

            }
        }

    }

}
