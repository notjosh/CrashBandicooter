import Foundation

enum Animation: CaseIterable {
    case jiggle
    case footStomp
    case pelvicThrust
    case turnAround
    case behindYou

    var range: ClosedRange<Int> {
        switch self {
        case .jiggle:
            return (0...15)
        case .footStomp:
            return (16...26)
        case .pelvicThrust:
            return (107...126)
        case .turnAround:
            return (49...68)
        case .behindYou:
            return (148...158)
        }
    }
}
