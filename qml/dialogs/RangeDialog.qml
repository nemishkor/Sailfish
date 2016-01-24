import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property int hueMin
    property int hueMax
    property int briMin
    property int briMax

    Column {
        width: parent.width
        spacing: Theme.paddingLarge
        DialogHeader { }

        Slider {
            id: hueMinSlider
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            value: hueMin
            minimumValue: 0
            maximumValue: hueMaxSlider.value - 1
            stepSize: 1
            valueText: value
            label: 'Hue minimum'
        }
        Slider {
            id: hueMaxSlider
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            value: hueMax
            minimumValue: hueMinSlider.value + 1
            maximumValue: 359
            valueText: value
            stepSize: 1
            label: 'Hue maximum'
        }

        Slider {
            id: briMinSlider
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            value: briMin
            minimumValue: 0
            maximumValue: briMaxSlider.value - 1
            stepSize: 1
            valueText: value
            label: 'Brightness minimum'
        }
        Slider {
            id: briMaxSlider
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            value: briMax
            minimumValue: briMinSlider.value + 1
            maximumValue: 99
            valueText: value
            stepSize: 1
            label: 'rightness maximum'
        }
    }

    onDone: {
        if (result === DialogResult.Accepted) {
            hueMin = hueMinSlider.value
            hueMax = hueMaxSlider.value
            briMin = briMinSlider.value
            briMax = briMaxSlider.value
        }
    }
}
