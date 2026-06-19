pragma Singleton

import QtQuick
import Quickshell

// Gruvbox dark palette shared across every bar widget. Kept in one place so the
// colours match the rest of the rice (vxwm, dunst, alacritty) without copying
// hex strings around.
Singleton {
    // backgrounds
    readonly property color bg:   "#282828" // bg0
    readonly property color bg1:  "#3c3836" // bg1
    readonly property color bg2:  "#504945" // bg2

    // foregrounds
    readonly property color fg:   "#ebdbb2" // fg1
    readonly property color gray: "#928374" // neutral gray (inactive)

    // accents
    readonly property color red:    "#fb4934"
    readonly property color green:  "#b8bb26"
    readonly property color yellow: "#fabd2f"
    readonly property color blue:   "#83a598"
    readonly property color aqua:   "#8ec07c"
    readonly property color orange: "#fe8019"

    // accent used for the active tag / highlights
    readonly property color accent: blue

    // dark, soft drop shadow blurred under glyphs so the transparent bar stays
    // legible over light wallpapers
    readonly property color shadow: "#d91d2021" // bg0_hard @ 85%

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13

    // bar geometry
    readonly property int barHeight: 26
    readonly property int padding: 10
}
