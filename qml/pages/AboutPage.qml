import QtQuick 2.0
import Sailfish.Silica 1.0

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

            Button{
                text: qsTr("Copy e-mail to clipboard ")
                onClicked: { mail.setClipboard("nemish94@gmail.com")  }
            }

            SectionHeader{
                text: 'ChangeLog'
            }

            Label{
                wrapMode: TextEdit.WordWrap
                text: '\tv.0.8\n' +
                      'changed view on itemPage\n' +
                      'added filters\n' +
                      'added view one record\n(open user info on click on userName)\n' +
                      '\tv.0.7\n' +
                      'added auto Deutsch translation\n' +
                      'added Russian\n' +
                      '\tv.0.6\n' +
                      'about page fix\n' +
                      'added favorites\n' +
                      'changed main page\n' +
                      'changed cover\n' +
                      'some fixes with history\n' +
                      'added download option' +
                      '\tv.0.3-4\n' +
                      'added global history\n' +
                      'added lovers page\n' +
                      'added statistics' +
                      'other fixes'
            }

            Item{
                width: parent.width
                height: Theme.paddingLarge
            }

        }



    }
}
