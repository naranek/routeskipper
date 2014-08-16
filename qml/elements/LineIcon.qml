import QtQuick 2.0

Image {
    property int size
    property string type

    id: lineIcon

    fillMode: Image.PreserveAspectFit
    smooth: true
    source: type !== "logo" ? "qrc:images/"+ size + "/" + type +  ".png" : "qrc:logo" // fix this later
}
