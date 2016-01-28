import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog{

    property int imgWidth;
    property int imgHeight;
    property int screenWidth;
    property int screenHeight;
    property int originalWidth;
    property int originalHeight;
    property string fileName;
    property bool blacken: false;
    property string overlayColor;
    property int overlayOpacity;

    SilicaFlickable{
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge
            DialogHeader { }

            ComboBox{
                id: imageSizeCombo
                label: qsTr("Image size")
                menu: ContextMenu{
                    MenuItem{ id: menuItem; text: qsTr("1x1 (for ambience)") }
                    MenuItem{ text: qsTr("screen size") }
                    MenuItem{ text: qsTr("original size") + " (" + originalWidth + "x" + originalHeight + ")" }
                }
            }

            IconTextSwitch {
                id: blackenSwitch
                text: qsTr("Blacken the edges")
                checked: blacken
                description: ""
            }

            IconTextSwitch {
                id: overlayColorSwitch
                text: qsTr("Add overlay color")
                description: qsTr("Choice color below")
                checked: blacken
            }

            BackgroundItem {
                id: colorPickerButton
                Row {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.paddingMedium
                    height: parent.height
                    spacing: Theme.paddingMedium
                    Rectangle {
                        id: colorIndicator

                        width: height
                        height: parent.height
                        color: "#e60003"
                    }
                    Label {
                        text: qsTr("Overlay color")
                        color: colorPickerButton.down ? Theme.highlightColor : Theme.primaryColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                onClicked: {
                    var page = pageStack.push("Sailfish.Silica.ColorPickerPage", { color: colorIndicator.color })
                    page.colorClicked.connect(function(color) {
                        colorIndicator.color = color
                        pageStack.pop()
                    })
                }
                Component {
                    id: colorPickerPage
                    ColorPickerPage {}
                }
            }

            Slider {
                id: overlayOpacitySlider
                visible: true
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                value: 60
                minimumValue: 0
                maximumValue: 255
                stepSize: 1
                valueText: value
                label: qsTr('Overlay opacity (less - more transparent)')
            }

        }
    }

    onDone: {
        if (result === DialogResult.Accepted) {
            switch(imageSizeCombo.currentIndex){
            case 0:
                if(screenHeight > screenWidth)
                    imgWidth = screenHeight
                else
                    imgWidth = screenWidth
                imgHeight = imgWidth
                break
            case 1:
                imgWidth = screenWidth
                imgHeight = screenHeight
                break
            case 2:
                imgWidth = originalWidth
                imgHeight = originalHeight
                break
            }
            if(overlayColorSwitch.checked === true)
                overlayColor = colorIndicator.color
            else
                overlayColor = "NULL"
            blacken = blackenSwitch.checked
            overlayOpacity = overlayOpacitySlider.value
            fileName += '_' + imgWidth + 'x' + imgHeight
        }
    }
}
