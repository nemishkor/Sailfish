import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    property string type

    property int hueMin
    property int hueMax
    property int briMin
    property int briMax
    property string lover
    property string keywords
    property string orderCol
    property string sortBy

    Component.onCompleted: {
        orderByCombo.currentIndex = 0
        sortByCombo.currentIndex = 0
        if(orderCol === "-")
            orderByCombo.currentIndex = 0
        if(orderCol === "dateCreated")
            orderByCombo.currentIndex = 1
        if(orderCol === "score")
            orderByCombo.currentIndex = 2
        if(orderCol === "name")
            orderByCombo.currentIndex = 3
        if(orderCol === "numVotes")
            orderByCombo.currentIndex = 4
        if(orderCol === "numViews")
            orderByCombo.currentIndex = 5
        if(sortBy === "-")
            sortByCombo.currentIndex = 0
        if(sortBy === "DESC")
            sortByCombo.currentIndex = 1
        if(sortBy === "ASC")
            sortByCombo.currentIndex = 2
    }

    SilicaFlickable{
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge
            DialogHeader { }

            TextField{
                id: loverLbl
                width: parent.width
                label: qsTr("Lover name")
                text: lover
                placeholderText: label
            }

            Row {
                ComboBox {
                    id: orderByCombo
                    width: column.width / 2
                    label: qsTr("Order by")
                    menu: ContextMenu {
                        MenuItem { text: qsTr("-") }
                        MenuItem { text: qsTr("Date created") }
                        MenuItem { text: qsTr("Score") }
                        MenuItem { text: qsTr("Name") }
                        MenuItem { text: qsTr("Number votes") }
                        MenuItem { text: qsTr("Number views") }
                    }
                }

                ComboBox {
                    id: sortByCombo
                    width: column.width / 2
                    label: qsTr("Sort by")
                    menu: ContextMenu {
                        MenuItem { text: qsTr("-") }
                        MenuItem { text: qsTr("DESC") }
                        MenuItem { text: qsTr("ASC") }
                    }
                }
            }

            Image{
                visible: (type === "colors") ? true : false
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/hue-line.png"
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
            }

            Slider {
                id: hueMinSlider
                visible: (type === "colors") ? true : false
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
                visible: (type === "colors") ? true : false
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
                visible: (type === "colors") ? true : false
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
                visible: (type === "colors") ? true : false
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                value: briMax
                minimumValue: briMinSlider.value + 1
                maximumValue: 99
                valueText: value
                stepSize: 1
                label: 'Brightness maximum'
            }

            TextField{
                id: keywordsLbl
                width: parent.width
                label: qsTr("Keywords")
                text: keywords
                placeholderText: label
            }

            Button {
                text: qsTr("Reset filters")
                anchors.horizontalCenter: parent.horizontalCenter
                preferredWidth: Theme.buttonWidthLarge
                onClicked: {
                    loverLbl.text = ""
                    orderByCombo.currentIndex = 0
                    sortByCombo.currentIndex = 0
                    hueMinSlider.value = 0
                    hueMaxSlider.value = 360
                    briMinSlider.value = 0
                    briMaxSlider.value = 100
                    keywordsLbl.text = ""
                }
            }

            Item{
                width: parent.width
                height: Theme.paddingLarge
            }

        }
    }

    onDone: {
        if (result === DialogResult.Accepted) {
//            var str = keywordsLbl.text
//            console.log(str)
//            var VRegExp = new RegExp(/^(\s|\u00A0)+/g);
//            str = str.replace(VRegExp, '+');
//            console.log(str)
            keywords = keywordsLbl.text
            switch(orderByCombo.currentIndex){
            case 0:
                orderCol = ""
                break
            case 1:
                orderCol = "dateCreated"
                break
            case 2:
                orderCol = "score"
                break
            case 3:
                orderCol = "name"
                break
            case 4:
                orderCol = "numVotes"
                break
            case 5:
                orderCol = "numViews"
            }
            switch(sortByCombo.currentIndex){
            case 0:
                sortBy = ""
                break
            case 1:
                sortBy = "DESC"
                break
            case 2:
                sortBy = "ASC"
                break
            }
            lover = loverLbl.text
            hueMin = hueMinSlider.value
            hueMax = hueMaxSlider.value
            briMin = briMinSlider.value
            briMax = briMaxSlider.value
        }
    }
}
