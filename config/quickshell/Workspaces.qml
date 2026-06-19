import QtQuick
import Quickshell
import Quickshell.Io

// Nine numbered tags. vxwm exports the focused tag through the EWMH
// _NET_CURRENT_DESKTOP property (needs EWMH_TAGS enabled in vxwm's config),
// which we follow live with `xprop -spy`. Clicking a tag replays the vxwm
// "view" keybind (Super+N) via xdotool, so no extra WM integration is needed.
Row {
    id: root
    spacing: 4

    property int count: 9
    property int current: 0 // 0-based index of the focused tag

    Repeater {
        model: root.count

        Rectangle {
            id: tag
            required property int index

            width: 22
            height: 20
            radius: 4
            color: index === root.current ? Theme.accent : "transparent"

            BarText {
                anchors.centerIn: parent
                text: tag.index + 1
                color: tag.index === root.current ? Theme.bg : Theme.fg
                shadow: tag.index !== root.current // active tag has a solid plate
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Quickshell.execDetached(["xdotool", "key", "super+" + (tag.index + 1)])
            }
        }
    }

    // Stream changes to the focused desktop. -spy keeps the process alive and
    // prints one line per change: "_NET_CURRENT_DESKTOP(CARDINAL) = 2".
    Process {
        running: true
        command: ["xprop", "-root", "-spy", "_NET_CURRENT_DESKTOP"]
        stdout: SplitParser {
            onRead: line => {
                const m = line.match(/=\s*(\d+)/);
                if (m)
                    root.current = parseInt(m[1]);
            }
        }
    }
}
