import Cocoa

protocol OptionsViewControllerDelegate: class {
    func updateAllowMovementAcrossScreen(isEnabled: Bool)
    func updateVariableLengthAnimations(isEnabled: Bool)
    func updateContinueDancingAfterCommand(isEnabled: Bool)
    func updateMusic(isEnabled: Bool)
    func updateSoundEffects(isEnabled: Bool)
}

class OptionsViewController: NSViewController {
    @IBOutlet private var allowMovementAcrossScreenButton: NSButton!
    @IBOutlet private var variableLengthAnimationsButton: NSButton!
    @IBOutlet private var continueDancingAfterCommandButton: NSButton!
    @IBOutlet private var musicButton: NSButton!
    @IBOutlet private var soundEffectsButton: NSButton!

    weak var delegate: OptionsViewControllerDelegate?

    func update(with options: Options) {
        allowMovementAcrossScreenButton.state = options.allowMovementAcrossScreen ? .on : .off
        variableLengthAnimationsButton.state = options.variableLengthAnimations ? .on : .off
        continueDancingAfterCommandButton.state = options.continueDancingAfterCommand ? .on : .off
        musicButton.state = options.isMusicEnabled ? .on : .off
        soundEffectsButton.state = options.isSoundEffectsEnabled ? .on : .off
    }

    @IBAction
    private func handleToggleAllowMovementAcrossScreen(sender: Any) {
        delegate?.updateAllowMovementAcrossScreen(isEnabled: allowMovementAcrossScreenButton.state == .on)
    }

    @IBAction
    private func handleToggleVariableLengthAnimations(sender: Any) {
        delegate?.updateVariableLengthAnimations(isEnabled: variableLengthAnimationsButton.state == .on)
    }

    @IBAction
    private func handleToggleContinueDancingAfterCommand(sender: Any) {
        delegate?.updateContinueDancingAfterCommand(isEnabled: continueDancingAfterCommandButton.state == .on)
    }

    @IBAction
    private func handleToggleMusic(sender: Any) {
        delegate?.updateMusic(isEnabled: musicButton.state == .on)
    }

    @IBAction
    private func handleToggleSoundEffects(sender: Any) {
        delegate?.updateSoundEffects(isEnabled: soundEffectsButton.state == .on)
    }
}
