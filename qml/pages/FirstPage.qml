/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Martin Jones <martin.jones@jollamobile.com>
** All rights reserved.
**
** This file is part of Sailfish Silica UI component package.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the Jolla Ltd nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: coverPage
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu{
            MenuItem{
                text: qsTr("About")
                onClicked: pageStack.push("AboutPage.qml")
            }
        }

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: "Colors explorer"
            }

            Image{
                fillMode: Image.TileHorizontally
                source: "qrc:/main/colors-bg.png"
            }

            SectionHeader{
                text: qsTr("Categories")
            }

            ComboBox {
                Image{
                    width: parent.width; height: parent.height - 2 * Theme.paddingSmall
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignRight
                    source: "qrc:/main/preview-category-color.png"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingSmall
                }
                label: "Colors"
                currentIndex: -1
                width: parent.width
                menu: ContextMenu {
                    MenuItem {
                        text: "New"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "colors",
                                               path: "/colors/color",
                                               category: text })
                        }
                    }
                    MenuItem {
                        text: "Top"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "colors",
                                               path: "/colors/color",
                                               category: text })
                        }
                    }
//                    MenuItem {
//                        text: "Random (exprerimental)"
//                        onClicked: {
//                            pageStack.push("ListPage.qml", {
//                                               type: "colors",
//                                               path: "/colors/color",
//                                               category: text })
//                        }
//                    }
                }
            }

            ComboBox {
                Image{
                    width: parent.width; height: parent.height - 2 * Theme.paddingSmall
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignRight
                    source: "qrc:/main/preview-category.png"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingSmall
                }
                label: "Palettes"
                currentIndex: -1
                width: parent.width
                menu: ContextMenu {
                    MenuItem {
                        text: "New"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "palettes",
                                               path: "/palettes/palette",
                                               heightDelegate: 220,
                                               category: text })
                        }
                    }
                    MenuItem {
                        text: "Top"
                        onClicked: {
                            pageStack.push("ListPage.qml", {
                                               type: "palettes",
                                               path: "/palettes/palette",
                                               heightDelegate: 220,
                                               category: text })
                        }
                    }
//                    MenuItem {
//                        text: "Random (exprerimental)"
//                        onClicked: {
//                            pageStack.push("ListPage.qml", {
//                                               type: "palettes",
//                                               path: "/palettes/palette",
//                                               heightDelegate: 220,
//                                               category: text })
//                        }
//                    }
                }
            }

            ComboBox {
                Image{
                    width: parent.width; height: parent.height - 2 * Theme.paddingSmall
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignRight
                    source: "qrc:/main/preview-category-patterns.png"
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingSmall
                }
                id: patterns
                label: "Patterns"
                currentIndex: -1
                width: parent.width
                menu: ContextMenu {
                    MenuItem {
                        text: "New"
                        onClicked: {
                            patterns.currentIndex = -1
                            pageStack.push("ListPage.qml", {
                                               type: "patterns",
                                               path: "/patterns/pattern",
                                               heightDelegate: 220,
                                               category: text })
                        }
                    }
                    MenuItem {
                        text: "Top"
                        onClicked: {
                            patterns.currentIndex = -1
                            pageStack.push("ListPage.qml", {
                                               type: "patterns",
                                               path: "/patterns/pattern",
                                               heightDelegate: 220,
                                               category: text })
                        }
                    }
//                    MenuItem {
//                        text: "Random (exprerimental)"
//                        onClicked: {
//                            patterns.currentIndex = -1
//                            pageStack.push("ListPage.qml", {
//                                               type: "patterns",
//                                               path: "/patterns/pattern",
//                                               heightDelegate: 220,
//                                               category: text })
//                        }
//                    }
                }
            }

            SectionHeader{
                text: qsTr("Tools")
            }
            BackgroundItem {
                width: parent.width
                Label {
                    id: firstName
                    text: qsTr("Color selector")
                    anchors.verticalCenter: parent.verticalCenter
                    x: Theme.horizontalPageMargin
                }
                onClicked: pageStack.push("ColorsSelectorPage.qml")
            }
        }
    }
}

