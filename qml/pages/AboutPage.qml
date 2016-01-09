import QtQuick 2.0
import Sailfish.Silica 1.0
import Clipboard 1.0

Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            x: Theme.paddingMedium
            width: page.width - 2 * Theme.paddingMedium
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("About")
            }

            Label {
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Hello my friend =)")
                font.pixelSize: Theme.fontSizeExtraLarge
            }

            Label{
                text: qsTr("You can email me suggestions or comments by e-mail: nemish94@gmail.com")
                width: parent.width
                wrapMode: TextEdit.WordWrap
            }

            TextEdit{
                id: mail
                visible: false
                function setClipboard(value) {
                    text = value
                    selectAll()
                    copy()
                }
            }

            Clip{
                id: clip
            }

            Button{
                text: "Copy e-mail to clipboard "
                onClicked: { mail.setClipboard("nemish94@gmail.com")  }

                //onClicked: { clip.copyToClipboard("nemish94@gmail.com") }
            }

        }



    }
}
