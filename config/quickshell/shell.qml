import Quickshell

// Entry point. One Bar per connected screen; Variants rebuilds the set when
// monitors are plugged or unplugged.
ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }
}
