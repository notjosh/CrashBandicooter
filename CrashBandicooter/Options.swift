import Foundation

struct Options {
    var allowMovementAcrossScreen: Bool {
        didSet {
            save()
        }
    }

    var variableLengthAnimations: Bool {
        didSet {
            save()
        }
    }

    var continueDancingAfterCommand: Bool {
        didSet {
            save()
        }
    }

    var isMusicEnabled: Bool {
        didSet {
            save()
        }
    }

    var isSoundEffectsEnabled: Bool {
        didSet {
            save()
        }
    }

    let userDefaults = UserDefaults.standard

    init() {
        userDefaults.register(defaults: [
            "allowMovementAcrossScreen": true,
            "variableLengthAnimations": true,
            "continueDancingAfterCommand": false,

            "isMusicEnabled": true,
            "isSoundEffectsEnabled": true,
        ])

        allowMovementAcrossScreen = userDefaults.bool(forKey: "allowMovementAcrossScreen")
        variableLengthAnimations = userDefaults.bool(forKey: "variableLengthAnimations")
        continueDancingAfterCommand = userDefaults.bool(forKey: "continueDancingAfterCommand")

        isMusicEnabled = userDefaults.bool(forKey: "isMusicEnabled")
        isSoundEffectsEnabled = userDefaults.bool(forKey: "isSoundEffectsEnabled")
    }

    private func save() {
        userDefaults.set(allowMovementAcrossScreen, forKey: "allowMovementAcrossScreen")
        userDefaults.set(variableLengthAnimations, forKey: "variableLengthAnimations")
        userDefaults.set(continueDancingAfterCommand, forKey: "continueDancingAfterCommand")

        userDefaults.set(isMusicEnabled, forKey: "isMusicEnabled")
        userDefaults.set(isSoundEffectsEnabled, forKey: "isSoundEffectsEnabled")

        userDefaults.synchronize()
    }
}
