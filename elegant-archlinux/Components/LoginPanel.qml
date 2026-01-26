import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import SddmComponents 2.0

Rectangle {
    id: loginPanel
    
    property color primaryColor: "#1793d1"
    property color textColor: "white"
    property color errorColor: "red"
    property color successColor: "steelblue"
    
    color: "#800C0C0C"
    property real cornerRadius: height / 25
    radius: cornerRadius

    TextConstants { id: textConstants }

    property real baseFontSize: height / 22.5

    ColumnLayout {
        id: mainColumn
        anchors.centerIn: parent
        width: parent.width * 0.9
        spacing: loginPanel.baseFontSize

        QQC2.Label {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            color: loginPanel.textColor
            text: textConstants.welcomeText.arg(sddm.hostName || "Arch Linux")
            wrapMode: Text.WordWrap
            font.pixelSize: loginPanel.height / 11.75
            elide: Text.ElideRight
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Math.round(loginPanel.height / 70)
            
            QQC2.Label {
                Layout.preferredWidth: loginPanel.width * 0.9 * 0.20
                Layout.preferredHeight: loginPanel.height / 9
                color: loginPanel.textColor
                text: textConstants.userName
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                font.pixelSize: loginPanel.baseFontSize
            }

            QQC2.TextField {
                id: name
                Layout.fillWidth: true
                Layout.preferredHeight: loginPanel.height / 9
                text: userModel.lastUser
                font.pixelSize: loginPanel.height / 20
                color: loginPanel.textColor
                horizontalAlignment: Text.AlignHCenter
                placeholderText: "whoami"
                placeholderTextColor: Qt.rgba(1, 1, 1, 0.5)
                
                background: Rectangle {
                    color: "transparent"
                    border.color: name.activeFocus ? loginPanel.primaryColor : "lightgrey"
                    border.width: Math.max(1, loginPanel.height / 500)
                    radius: loginPanel.cornerRadius / 2
                }

                KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(name.text, password.text, session.currentIndex)
                        event.accepted = true
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Math.round(loginPanel.height / 70)
            
            QQC2.Label {
                Layout.preferredWidth: loginPanel.width * 0.9 * 0.2
                Layout.preferredHeight: loginPanel.height / 9
                color: loginPanel.textColor
                text: textConstants.password
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                font.pixelSize: loginPanel.baseFontSize
            }

            QQC2.TextField {
                id: password
                Layout.fillWidth: true
                Layout.preferredHeight: loginPanel.height / 9
                font.pixelSize: loginPanel.height / 20
                color: loginPanel.textColor
                horizontalAlignment: Text.AlignHCenter
                placeholderText: "password"
                placeholderTextColor: Qt.rgba(1, 1, 1, 0.5)
                echoMode: TextInput.Password
                focus: true
                
                background: Rectangle {
                    color: "transparent"
                    border.color: password.activeFocus ? loginPanel.primaryColor : "lightgrey"
                    border.width: Math.max(1, loginPanel.height / 500)
                    radius: loginPanel.cornerRadius / 2
                }

                Timer {
                    interval: 200
                    running: true
                    onTriggered: password.forceActiveFocus()
                }

                KeyNavigation.backtab: name; KeyNavigation.tab: session

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(name.text, password.text, session.currentIndex)
                        event.accepted = true
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Math.round(loginPanel.height / 70)
            z: 100

            QQC2.Label {
                Layout.preferredWidth: loginPanel.width * 0.9 * 0.2
                Layout.preferredHeight: loginPanel.height / 9
                color: loginPanel.textColor
                text: textConstants.session
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                font.pixelSize: loginPanel.baseFontSize
            }


            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
            }

            QQC2.ComboBox {
                id: session
                Layout.preferredWidth: implicitWidth
                Layout.preferredHeight: loginPanel.height / 9
                font.pixelSize: loginPanel.height / 20

                model: sessionModel
                textRole: "name"
                currentIndex: sessionModel.lastIndex

                property real maxDropdownWidth: 0

                Repeater {
                    model: sessionModel
                    delegate: Text {
                        id: measurer
                        visible: false
                        text: name
                        font: session.font
                        onContentWidthChanged: {
                            var w = measurer.contentWidth + (loginPanel.width * 0.05) + (session.indicator.width * 2)
                            if (w > session.maxDropdownWidth) {
                                session.maxDropdownWidth = w
                            }
                        }
                    }
                }

                indicator: Image {
                    x: session.width - width - (session.rightPadding / 2)
                    y: session.topPadding + (session.availableHeight - height) / 2
                    width: parent.height * 0.4
                    height: width
                    source: Qt.resolvedUrl("../Assets/angle-down.svg")
                    fillMode: Image.PreserveAspectFit
                }
                
                background: Rectangle {
                    color: "transparent"
                    border.width: 0
                }
                
                contentItem: Text {
                    leftPadding: 0
                    rightPadding: session.indicator.width
                    text: session.displayText
                    font: session.font
                    color: loginPanel.textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                delegate: QQC2.ItemDelegate {
                    width: session.popup.width
                    contentItem: Text {
                        text: name
                        color: (session.highlightedIndex === index || hovered) ? "white" : loginPanel.textColor
                        font: session.font
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    background: Rectangle {
                        color: (session.highlightedIndex === index || hovered) ? loginPanel.primaryColor : "transparent"
                    }
                    highlighted: session.highlightedIndex === index
                }

                popup: QQC2.Popup {
                    y: parent.height
                    x: (parent.width - width - session.indicator.width) / 2
                    width: Math.max(parent.width, session.maxDropdownWidth)
                    implicitHeight: contentItem.implicitHeight
                    padding: 0

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: session.popup.visible ? session.delegateModel : null
                        currentIndex: session.highlightedIndex

                        QQC2.ScrollIndicator.vertical: QQC2.ScrollIndicator { }
                    }

                    background: Rectangle {
                        color: "#2a2a2a"
                        radius: loginPanel.cornerRadius
                        border.color: loginPanel.primaryColor
                        border.width: Math.max(1, loginPanel.height / 500)
                    }
                }

                KeyNavigation.backtab: password; KeyNavigation.tab: loginButton
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
            }
        }

        QQC2.Label {
            id: errorMessage
            Layout.alignment: Qt.AlignHCenter
            text: textConstants.prompt
            color: loginPanel.textColor
            font.pixelSize: loginPanel.baseFontSize
    
            Connections {
                target: sddm
                function onLoginSucceeded() {
                    errorMessage.color = loginPanel.successColor
                    errorMessage.text = textConstants.loginSucceeded
                }
                function onLoginFailed() {
                    errorMessage.color = loginPanel.errorColor
                    errorMessage.text = textConstants.loginFailed
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Math.round(loginPanel.height / 70)
            
            property int btnWidth: Math.max(loginButton.implicitWidth,
                                            shutdownButton.implicitWidth,
                                            rebootButton.implicitWidth, loginPanel.height / 3) + 8

            QQC2.Button {
                id: loginButton
                text: textConstants.login
                Layout.preferredWidth: parent.btnWidth
                Layout.preferredHeight: loginPanel.height / 9
                
                contentItem: Text {
                    text: loginButton.text
                    font.pixelSize: loginPanel.height / 20
                    color: loginButton.hovered ? loginPanel.primaryColor : "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: loginButton.down ? Qt.darker("white", 1.2) : 
                           (loginButton.hovered ? "white" : loginPanel.primaryColor)
                    radius: loginPanel.cornerRadius
                    border.color: loginButton.hovered ? "white" : "transparent"
                    border.width: loginButton.hovered ? Math.max(1, loginPanel.height / 500) : 0
                }

                onClicked: sddm.login(name.text, password.text, session.currentIndex)

                KeyNavigation.tab: shutdownButton
            }

            QQC2.Button {
                id: shutdownButton
                text: textConstants.shutdown
                Layout.preferredWidth: parent.btnWidth
                Layout.preferredHeight: loginPanel.height / 9
                
                contentItem: Text {
                    text: shutdownButton.text
                    font.pixelSize: loginPanel.height / 20
                    color: shutdownButton.hovered ? loginPanel.primaryColor : "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: shutdownButton.down ? Qt.darker("white", 1.2) : 
                           (shutdownButton.hovered ? "white" : loginPanel.primaryColor)
                    radius: loginPanel.cornerRadius
                    border.color: shutdownButton.hovered ? "white" : "transparent"
                    border.width: shutdownButton.hovered ? Math.max(1, loginPanel.height / 500) : 0
                }

                onClicked: sddm.powerOff()

                KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
            }

            QQC2.Button {
                id: rebootButton
                text: textConstants.reboot
                Layout.preferredWidth: parent.btnWidth
                Layout.preferredHeight: loginPanel.height / 9

                contentItem: Text {
                    text: rebootButton.text
                    font.pixelSize: loginPanel.height / 20
                    color: rebootButton.hovered ? loginPanel.primaryColor : "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: rebootButton.down ? Qt.darker("white", 1.2) : 
                           (rebootButton.hovered ? "white" : loginPanel.primaryColor)
                    radius: loginPanel.cornerRadius
                    border.color: rebootButton.hovered ? "white" : "transparent"
                    border.width: rebootButton.hovered ? Math.max(1, loginPanel.height / 500) : 0
                }

                onClicked: sddm.reboot()

                KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
