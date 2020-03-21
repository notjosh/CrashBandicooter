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
    func handleMenuStartDance(sender: Any) {
        crashViewController.handleMenuStartDance(sender: sender)
    }

    @IBAction
    func handleMenuStop(sender: Any) {
        crashViewController.handleMenuStop(sender: sender)
    }

    @IBAction
    func handleMenuRandom(sender: Any) {
        crashViewController.handleMenuRandom(sender: sender)
    }

    @IBAction
    func handleMenuJiggle(sender: Any) {
        crashViewController.handleMenuJiggle(sender: sender)
    }

    @IBAction
    func handleMenuFootStomp(sender: Any) {
        crashViewController.handleMenuFootStomp(sender: sender)
    }

    @IBAction
    func handleMenuPelvicThrust(sender: Any) {
        crashViewController.handleMenuPelvicThrust(sender: sender)
    }

    @IBAction
    func handleMenuTurnAround(sender: Any) {
        crashViewController.handleMenuTurnAround(sender: sender)
    }

    @IBAction
    func handleMenuBehindYou(sender: Any) {
        crashViewController.handleMenuBehindYou(sender: sender)
    }

    @IBAction
    func showAbout(sender: Any) {
        crashViewController.handleMenuAboutCrash(sender: sender)
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

