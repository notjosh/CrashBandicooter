import Cocoa

class Window: NSWindow {
    override var isMovableByWindowBackground: Bool {
        get {
            true
        }
        set {
            super.isMovableByWindowBackground = true
        }
    }

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)

        isOpaque = false
        backgroundColor = .clear

        level = .floating

        center()
    }
}
