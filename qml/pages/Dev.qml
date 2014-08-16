import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/HSL-functions.js" as HSL
import "../js/DatabaseTools.js" as DbTools
import "../models" as Models
import "../elements" as Elements


Page {
    BackgroundItem {
        width: 300; height: 100;
        Rectangle {
            width: 200; height: 100



            SilicaFlickable {
                anchors.fill: parent
                contentWidth: text.width; contentHeight: text.height

                Text {
                    id: text
                    text: "Hello, Sailor!"
                    font.pixelSize: 100
                }
            }

        }
    }
}
