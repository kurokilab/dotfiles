import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

// Collapsible StatusNotifier tray: only a chevron shows by default; clicking it
// reveals the icons. Left-click activates an item, middle-click is the secondary
// action, right-click opens the item's own menu anchored under it.
Row {
    id: root
    spacing: 10

    // the PanelWindow, needed as the anchor surface for tray menus
    property var panel
    property bool expanded: false

    // tray icons — collapsed away (invisible items take no space in a Row)
    Row {
        id: items
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter
        visible: root.expanded
        opacity: root.expanded ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }

        Repeater {
            model: SystemTray.items

            Item {
                id: entry
                required property SystemTrayItem modelData

                width: 18
                height: 18
                anchors.verticalCenter: parent.verticalCenter

                IconImage {
                    anchors.fill: parent
                    source: entry.modelData.icon
                    asynchronous: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton)
                            entry.modelData.activate();
                        else if (mouse.button === Qt.MiddleButton)
                            entry.modelData.secondaryActivate();
                        else if (entry.modelData.hasMenu)
                            menuAnchor.open();
                    }
                }

                QsMenuAnchor {
                    id: menuAnchor
                    menu: entry.modelData.menu
                    anchor.window: root.panel
                    anchor.rect.x: entry.mapToItem(null, 0, 0).x
                    anchor.rect.y: Theme.barHeight
                }
            }
        }
    }

    // chevron toggle: points left when there is hidden tray to reveal
    BarText {
        id: chevron
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.fg
        text: root.expanded ? "󰅂" : "󰅁" // 󰅂 collapse (right) : 󰅁 expand (left)

        MouseArea {
            id: chevronArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expanded = !root.expanded
        }
    }
}
