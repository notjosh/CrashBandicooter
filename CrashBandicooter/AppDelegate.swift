import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction
    func showOptions(sender: Any) {
        crashViewController.handleMenuOptions(sender: sender)
    }

    private var crashViewController: ViewController {
        NSApp
            .windows
            .first { $0 is Window }!
            .contentViewController as! ViewController
    }
}

