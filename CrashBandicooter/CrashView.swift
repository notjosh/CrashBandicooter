import Cocoa

protocol CrashViewDelegate: class {
    func jump(distance: CGSize)
    func play(soundEffect: SoundEffect)
    func loopCount() -> Int
    func shouldContinueDancingAfterCommand() -> Bool
}

fileprivate enum FrameEvent {
    case jump(distance: CGSize)
    case play(soundEffect: SoundEffect)
    case markLoopEntry
    case markLoopExit
}

private let increment = CGFloat(20)

private let jumpSE = CGSize(width: increment, height: increment)
private let jumpSW = CGSize(width: -increment, height: increment)
private let jumpNE = CGSize(width: increment, height: -increment)
private let jumpNW = CGSize(width: -increment, height: -increment)

class CrashView: NSView {
    var frames = [NSImage]() {
        didSet {
            frameNumber = 0

            if frames.isEmpty {
                print("Warning: got 0 frames for CrashView")
            }
        }
    }

    typealias Frame = Int

    weak var delegate: CrashViewDelegate?

    private var frameNumber = Frame(0)
    private var stopFrame: Frame?
    private var timer: Timer?
    private var loopCount: Int = 0
    private var loopFrameNumber: Frame?

    lazy private var frameEvents: [Frame: [FrameEvent]] = {
        return [
            4: [.play(soundEffect: SoundEffect.randomStep)],
            11: [.play(soundEffect: SoundEffect.randomStep)],

            17: [.play(soundEffect: .whoosh)],
            23: [.play(soundEffect: .whoosh)],

            34: [.jump(distance: jumpSE), .play(soundEffect: .boink)],
            35: [.markLoopEntry],
            36: [.jump(distance: jumpSE), .play(soundEffect: .boink)],
            37: [.markLoopExit],

            42: [.jump(distance: jumpSW), .play(soundEffect: .boink)],
            44: [.jump(distance: jumpSW), .play(soundEffect: .boink)],
            45: [.markLoopEntry],
            46: [.jump(distance: jumpSW), .play(soundEffect: .boink)],
            47: [.markLoopExit],

            53: [.play(soundEffect: SoundEffect.randomStep)],
            60: [.play(soundEffect: SoundEffect.randomStep)],
            63: [.play(soundEffect: SoundEffect.randomStep)],

            69: [.play(soundEffect: .whoosh)],

            // back side, offset by 79:

            4 + 79: [.play(soundEffect: SoundEffect.randomStep)],
            11 + 79: [.play(soundEffect: SoundEffect.randomStep)],

            17 + 79: [.play(soundEffect: .whoosh)],
            23 + 79: [.play(soundEffect: .whoosh)],

            111: [.jump(distance: jumpNW), .play(soundEffect: .boink)],
            115: [.jump(distance: jumpNW), .play(soundEffect: .boink)],
            116: [.markLoopEntry],
            117: [.jump(distance: jumpNW), .play(soundEffect: .boink)],
            118: [.markLoopExit],

            121: [.jump(distance: jumpNE), .play(soundEffect: .boink)],
            122: [.markLoopEntry],
            123: [.jump(distance: jumpNE), .play(soundEffect: .boink)],
            124: [.markLoopExit],

            53 + 79: [.play(soundEffect: SoundEffect.randomStep)],
            60 + 79: [.play(soundEffect: SoundEffect.randomStep)],
            63 + 79: [.play(soundEffect: SoundEffect.randomStep)],

            69 + 79: [.play(soundEffect: .whoosh)],
        ]
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        wantsLayer = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        wantsLayer = true
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }

    func toggle() {
        if timer == nil {
            start()
        } else {
            stop()
        }
    }

    func start(startingAt start: Animation? = nil) {
        if timer != nil {
            if let start = start {
                seek(to: start)
            }

            return
        }

        // 12 fps
        let newtimer = Timer(timeInterval: 1 / 12, repeats: true, block: tick)

        RunLoop.current.add(newtimer, forMode: .common)

        timer = newtimer

        stopFrame = nil
        loopCount = 0
        loopFrameNumber = nil

        if let start = start {
            seek(to: start)
            stopFrame = start.range.upperBound
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil

        frameNumber = 0
        stopFrame = nil
        setNeedsDisplay(bounds)
    }

    private func tick(_ timer: Timer) {
        frameNumber += 1
        frameNumber %= frames.count

        if let evts = frameEvents[frameNumber] {
            evts.forEach { [weak self] evt in
                switch evt {
                case .jump(let distance):
                    self?.delegate?.jump(distance: distance)
                case .play(let soundEffect):
                    self?.delegate?.play(soundEffect: soundEffect)
                case .markLoopEntry:
                    if loopFrameNumber == nil {
                        loopFrameNumber = frameNumber
                        loopCount = self?.delegate?.loopCount() ?? 0
                    }
                case .markLoopExit:
                    loopCount -= 1

                    if loopCount <= 0 {
                        loopFrameNumber = nil
                    }

                    if let loopFrameNumber = loopFrameNumber {
                        frameNumber = loopFrameNumber
                    }
                }
            }
        }

        if frameNumber == stopFrame {
            if delegate?.shouldContinueDancingAfterCommand() ?? false {
                stopFrame = nil
            } else {
                stop()
            }
        }

        setNeedsDisplay(bounds)
    }

    private func seek(to animation: Animation) {
        frameNumber = animation.range.lowerBound
    }

    override func draw(_ dirtyRect: NSRect) {
        let image = frames[frameNumber]

        image.draw(in: bounds)
    }
}
