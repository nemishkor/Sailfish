import QtQuick 2.0
import Sailfish.Silica 1.0

Page{
    id: page
    orientation: orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: qsTr("Create ambience")
            }

            Label{
                x: Theme.paddingSmall
                width: parent.width - 2 * Theme.paddingMedium
                text: "For create own ambience:"
                color: Theme.highlightColor
            }

            Label{
                x: Theme.paddingSmall
                width: parent.width - 2 * Theme.paddingMedium
                text: qsTr("1. Open some pattern.\n" +
                           "2. Pull down page and choice 'Save to gallery'.\n" +
                           "3. Open image in gallery and choice in menu 'Create ambience'\n")
                wrapMode: Text.WordWrap
            }

            Label{
                x: Theme.paddingSmall
                width: parent.width - 2 * Theme.paddingMedium
                text: qsTr("Your pattern will be saved with your device screen size")
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
            }

        }
    }
}

