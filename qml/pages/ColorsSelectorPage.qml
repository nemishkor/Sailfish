import QtQuick 2.0
import Sailfish.Silica 1.0
import "../content"
import "../content/ColorUtils.js" as ColorUtils

//*
Page {
    id: page
    SilicaFlickable {
        id: listView
        anchors.fill: parent
        contentHeight: column.height + header.height

        PageHeader{
            id: header
            title: "Color picker"
        }

        Column{
            id: column
            y: header.height
            width: parent.width

            // details column

            Label{
                x: Theme.paddingMedium
                text: qsTr("Choised color")
                Rectangle {
                    anchors.left: parent.right
                    width: column.width - parent.width - 3 * Theme.paddingMedium; height: parent.height
                    anchors.leftMargin: Theme.paddingMedium
                    radius: 10
                    border.width: 1; border.color: "black"
                    anchors.top: parent.top
                    color: colorPicker.colorValue
                    //Checkerboard { cellSide: 5 }
//                    Rectangle {
//                        width: 500; height: 30
//                        border.width: 1; border.color: "black"
//                        color: colorPicker.colorValue
//                    }
                }
            }

            SectionHeader{
                text: qsTr("Color picker")
            }

            Rectangle {
                id: colorPicker
                property color colorValue: ColorUtils.hsba(hueSlider.value, sbPicker.saturation,
                                                           sbPicker.brightness, alphaSlider.value)
                width: parent.width; height: width * 0.8
                //anchors.top: colorEditBox
                //color: ColorUtils.hsba(hueSlider.value, sbPicker.saturation, sbPicker.brightness, alphaSlider.value)
                color: "transparent"

                Row {
                    spacing: 3
                    anchors.fill: parent

                    // saturation/brightness picker box
                    SBPicker {
                        id: sbPicker
                        hueColor : ColorUtils.hsba(hueSlider.value, 1, 1, 1)
                        width: parent.width * 0.8; height: width
                    }

                    // hue picking slider
                    Item {
                        width: parent.width * 0.1; height: parent.width * 0.8;
                        Rectangle {
                            radius: 10
                            anchors.fill: parent
                            gradient: Gradient {
                                GradientStop { position: 1.0;  color: "#FF0000" }
                                GradientStop { position: 0.85; color: "#FFFF00" }
                                GradientStop { position: 0.76; color: "#00FF00" }
                                GradientStop { position: 0.5;  color: "#00FFFF" }
                                GradientStop { position: 0.33; color: "#0000FF" }
                                GradientStop { position: 0.16; color: "#FF00FF" }
                                GradientStop { position: 0.0;  color: "#FF0000" }
                            }
                        }
                        Item {
                            id: hueSlider;
                            anchors.fill: parent
                            property real value: 1 - pickerCursor.y/height
                            Item {
                                id: pickerCursor
                                y: 1
                                width: parent.width
                                Rectangle {
                                    x: -3; y: -height*0.5
                                    width: parent.width + 4; height: 7
                                    border.color: "black"; border.width: 1
                                    color: "transparent"
                                    Rectangle {
                                        anchors.fill: parent; anchors.margins: 2
                                        border.color: "white"; border.width: 1
                                        color: "transparent"
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                function handleMouse(mouse) {
                                    if (mouse.buttons & Qt.LeftButton) {
                                        pickerCursor.y = Math.max(0, Math.min(height, mouse.y))
                                        sbPicker.hueColor = ColorUtils.hsba(hueSlider.value, 1, 1, 1)
                                    }
                                }
                                onPositionChanged: handleMouse(mouse)
                                onPressed: handleMouse(mouse)
                            }
                        }
                    }

                    // alpha (transparency) picking slider
                    Item {
                        id: alphaPicker
                        width: parent.width * 0.1; height: parent.width * 0.8;
                        Checkerboard { cellSide: 4 }
                        //  alpha intensity gradient background
                        Rectangle {
                            radius: 10
                            anchors.fill: parent
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#FF000000" }
                                GradientStop { position: 1.0; color: "#00000000" }
                            }
                        }
                        ColorSlider { id: alphaSlider; anchors.fill: parent }
                    }
                }
            }

            SectionHeader{
                text: qsTr("Details")
            }

            Label{
                id: hueLbl
                text: "Hue: " + (hueSlider.value * 360).toFixed(2)
            }

            Label{
                text: qsTr("form 0 to 360")
                font.pixelSize: Theme.fontSizeExtraSmall
                x: Theme.paddingMedium
            }

            Label{
                id: satLbl
                text: "Saturation: " + (sbPicker.saturation * 100).toFixed(2)
            }

            Label{
                text: qsTr("form 0 to 100")
                font.pixelSize: Theme.fontSizeExtraSmall
                x: Theme.paddingMedium
            }

            Label{
                id: briLbl
                text: "Brightness: " + (sbPicker.brightness * 100).toFixed(2)
            }

            Label{
                text: qsTr("form 0 to 100")
                font.pixelSize: Theme.fontSizeExtraSmall
                x: Theme.paddingMedium
            }

            Label{
                id: alpLbl
                text: "Alpha: " + ((alphaSlider.value * 100).toFixed(2))
            }

            Label{
                text: qsTr("form 0 to 100")
                font.pixelSize: Theme.fontSizeExtraSmall
                x: Theme.paddingMedium
            }

            // "#XXXXXXXX" color value box
            TextField {
                width: parent.width
                label: "Hex"
                placeholderText: "Type here"
                maximumLength: 9
                horizontalAlignment: TextInput.AlignLeft
                text: ColorUtils.fullColorString(colorPicker.colorValue, alphaSlider.value)
                EnterKey.onClicked: {
                    text = "Return key pressed";
                    parent.focus = true;
                }
            }



//                        // H, S, B color values boxes
//                        Column {
//                            width: parent.width
//                            NumberBox { caption: "H:"; value: hueSlider.value.toFixed(2) }
//                            NumberBox { caption: "S:"; value: sbPicker.saturation.toFixed(2) }
//                            NumberBox { caption: "B:"; value: sbPicker.brightness.toFixed(2) }
//                        }

//                        // filler rectangle
//                        Rectangle {
//                            width: parent.width; height: 5
//                            color: "transparent"
//                        }

//                        // R, G, B color values boxes
//                        Column {
//                            width: parent.width
//                            NumberBox {
//                                caption: "R:"
//                                value: ColorUtils.getChannelStr(colorPicker.colorValue, 0)
//                                min: 0; max: 255
//                            }
//                            NumberBox {
//                                caption: "G:"
//                                value: ColorUtils.getChannelStr(colorPicker.colorValue, 1)
//                                min: 0; max: 255
//                            }
//                            NumberBox {
//                                caption: "B:"
//                                value: ColorUtils.getChannelStr(colorPicker.colorValue, 2)
//                                min: 0; max: 255
//                            }
//                        }

//                        // alpha value box
//                        NumberBox {
//                            caption: "A:"; value: Math.ceil(alphaSlider.value*255)
//                            min: 0; max: 255
//                        }


//            Rectangle{
//                width: parent.width - 2 * Theme.paddingMedium
//                height: width
//                border.color: "pink"
//                border.width: 1
//                color: "transparent"
//                Image{
//                    id: hueImage
//                    anchors.fill: parent
//                    source: "qrc:/iconPrefix/images/hue.png"
//                    property int radius: hueImage / 2
//                    MouseArea{
//                        anchors.fill: hueImage
//                        onClicked: function(){
//                            console.log(mouseX + " " + mouseY)
//                        }
//                    }
//                }
//            }

        }
    }
}
