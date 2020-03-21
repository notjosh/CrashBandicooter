import Cocoa
import AVFoundation

class ViewController: NSViewController {
    @IBOutlet private var crashView: CrashView!
    @IBOutlet private var danceMenu: NSMenu!

    private var options = Options()

    // TODO: can we derive this from, say, view.menu or something?
    private var menuVisible: Bool = false

    private var backgroundSound: NSSound?

    let starling = Starling()

    override func viewDidLoad() {
        super.viewDidLoad()

        danceMenu.delegate = self

        backgroundSound = Music.long.sound
        backgroundSound?.loops = true

        SoundEffect
            .allCases
            .forEach { soundEffect in
                guard let url = soundEffect.url else {
                    return
                }

                starling.load(
                    sound: url,
                    for: soundEffect.soundIdentifier
                )
            }

        let gr = NSClickGestureRecognizer()
        gr.target = self
        gr.action = #selector(ViewController.handleClickGesture(gr:))
        crashView.addGestureRecognizer(gr)

        crashView.delegate = self

        let files = Bundle(for: ViewController.self)
            .urls(forResourcesWithExtension: "png", subdirectory: "tiles") ?? []

        crashView.frames = files
            .sorted { $0.absoluteString < $1.absoluteString }
            .map { NSImage(contentsOf: $0) }
            .compactMap { $0 }

        crashView.start()
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        if options.isMusicEnabled {
            startBackgroundMusic()
        }
    }

    override func rightMouseDown(with event: NSEvent) {
        let point = event.locationInWindow

        danceMenu.popUp(positioning: nil, at: point, in: view)
    }

    @objc
    private func handleClickGesture(gr: NSClickGestureRecognizer) {
        crashView.toggle()
    }

    @IBAction
    private func handleMenuStartDance(sender: Any) {
        crashView.start()
    }

    @IBAction
    private func handleMenuStop(sender: Any) {
        crashView.stop()
    }

    @IBAction
    private func handleMenuRandom(sender: Any) {
        guard let random = Animation.allCases.randomElement() else {
            return
        }

        crashView.start(startingAt: random)
    }

    @IBAction
    private func handleMenuJiggle(sender: Any) {
        crashView.start(startingAt: .jiggle)
    }

    @IBAction
    private func handleMenuFootStomp(sender: Any) {
        crashView.start(startingAt: .footStomp)
    }

    @IBAction
    private func handleMenuPelvicThrust(sender: Any) {
        crashView.start(startingAt: .pelvicThrust)
    }

    @IBAction
    private func handleMenuTurnAround(sender: Any) {
        crashView.start(startingAt: .turnAround)
    }

    @IBAction
    private func handleMenuBehindYou(sender: Any) {
        crashView.start(startingAt: .behindYou)
    }

    @IBAction
    func handleMenuOptions(sender: Any) {
        optionsViewController.update(with: options)
        optionsViewController.delegate = self

        optionsWindowController.showWindow(self)
        optionsWindowController.window?.orderFront(self)
    }

    @IBAction
    private func handleMenuAboutCrash(sender: Any) {
        aboutWindowController.showWindow(self)
        aboutWindowController.window?.orderFront(self)
    }

    @IBAction
    private func handleMenuByeBye(sender: Any) {
        NSApp.terminate(self)
    }

    lazy private var aboutWindowController: NSWindowController = {
        return storyboard!.instantiateController(withIdentifier: "AboutWindow") as! NSWindowController
    }()

    lazy private var optionsWindowController: NSWindowController = {
        return storyboard!.instantiateController(withIdentifier: "OptionsWindow") as! NSWindowController
    }()

    lazy private var optionsViewController: OptionsViewController = {
        return optionsWindowController.contentViewController as! OptionsViewController
    }()

    private func startBackgroundMusic() {
        backgroundSound?.play()
    }

    private func stopBackgroundMusic() {
        backgroundSound?.stop()
    }
}

extension ViewController: CrashViewDelegate {
    func play(soundEffect: SoundEffect) {
        guard options.isSoundEffectsEnabled else {
            return
        }

        starling.play(soundEffect.soundIdentifier, allowOverlap: true)
    }

    func jump(distance: CGSize) {
        guard let window = view.window else {
            return
        }

        guard options.allowMovementAcrossScreen else {
            return
        }

        guard menuVisible == false else {
            return
        }

        var point = window.frame.origin

        point.x += distance.width
        point.y -= distance.height

        // keep Crash on the screen, if we know the screen frame
        if let screen = window.screen {
            let bounds = screen.visibleFrame

            if point.x < bounds.minX {
                point.x = bounds.minX
            }

            if point.y < bounds.minY {
                point.y = bounds.minY
            }

            if point.x + window.frame.width > bounds.maxX {
                point.x = bounds.maxX - window.frame.width
            }

            if point.y + window.frame.height > bounds.maxY {
                point.y = bounds.maxY - window.frame.height
            }
        }

        window.setFrameOrigin(point)
    }

    func loopCount() -> Int {
        guard options.variableLengthAnimations else {
            return 0
        }

        return Int.random(in: 0...5)
    }

    func shouldContinueDancingAfterCommand() -> Bool {
        return options.continueDancingAfterCommand
    }
}

extension ViewController: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        menuVisible = true
    }

    func menuDidClose(_ menu: NSMenu) {
        menuVisible = false
    }
}

extension ViewController: OptionsViewControllerDelegate {
    func updateAllowMovementAcrossScreen(isEnabled: Bool) {
        options.allowMovementAcrossScreen = isEnabled
    }

    func updateVariableLengthAnimations(isEnabled: Bool) {
        options.variableLengthAnimations = isEnabled
    }

    func updateContinueDancingAfterCommand(isEnabled: Bool) {
        options.continueDancingAfterCommand = isEnabled
    }

    func updateMusic(isEnabled: Bool) {
        options.isMusicEnabled = isEnabled

        if isEnabled {
            startBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }

    func updateSoundEffects(isEnabled: Bool) {
        options.isSoundEffectsEnabled = isEnabled
    }
}
