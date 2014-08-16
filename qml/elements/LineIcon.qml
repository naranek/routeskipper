import QtQuick 2.0

Image {
    property int size
    property string type

    id: lineIcon
    width: size; height: size
    fillMode: Image.PreserveAspectFit
    smooth: true
    source: "qrc:" + type
}
