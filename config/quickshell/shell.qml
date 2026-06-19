import Quickshell

// Entry point. One Bar per connected screen; Variants rebuilds the set when
// monitors are plugged or unplugged.
ShellRoot {
    id: root

    // Shared visibility for every Bar instance. Toggled over IPC so the bar can
    // be hidden without killing the process — that keeps the system tray's
    // registrations alive instead of forcing every applet to reconnect.
    property bool barVisible: true

    // `qs ipc call bar toggle|show|hide` drives this from the window manager.
    IpcHandler {
        target: "bar"

        function toggle(): void { root.barVisible = !root.barVisible }
        function show(): void { root.barVisible = true }
        function hide(): void { root.barVisible = false }
    }

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
            // Hiding releases the exclusion strut, so vxwm reclaims the space.
            visible: root.barVisible
        }
    }
}
