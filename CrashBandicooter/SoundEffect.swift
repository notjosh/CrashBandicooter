import Cocoa
import AVFoundation

protocol WavFile {
    var fileName: String { get }
}

extension WavFile {
    var url: URL? {
        return Bundle
            .main
            .url(
                forResource: fileName,
                withExtension: "wav",
                subdirectory: "sounds"
            )
    }

    var sound: NSSound? {
        guard let url = url else {
            return nil
        }

        return NSSound(contentsOf: url, byReference: false)
    }

    var audioPlayer: AVAudioPlayer? {
        guard let url = url else {
            return nil
        }

        return try? AVAudioPlayer(contentsOf: url)
    }

    var soundIdentifier: SoundIdentifier {
        return String(describing: self)
    }
}

enum Music: WavFile {
    case short
    case long

    var fileName: String {
        switch self {
        case .short:
            return "crash.exe_WAVE_181"
        case .long:
            return "crash.exe_WAVE_185"
        }
    }
}

enum SoundEffect: WavFile, CaseIterable {
    case step1
    case step2
    case step3
    case boink
    case whoosh

    private static var steps: [SoundEffect] {
        return [
            .step1,
            .step2,
            .step3
        ]
    }

    static var randomStep: SoundEffect {
        return steps.randomElement() ?? .step1
    }

    var fileName: String {
        switch self {
        case .step1:
            return "crash.exe_WAVE_186"
        case .step2:
            return "crash.exe_WAVE_187"
        case .step3:
            return "crash.exe_WAVE_188"
        case .boink:
            return "crash.exe_WAVE_190"
        case .whoosh:
            return "crash.exe_WAVE_189"
        }
    }
}
