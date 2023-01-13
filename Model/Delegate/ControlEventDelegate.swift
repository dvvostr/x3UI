import UIKit

@objc public protocol ControlEventDelegate {
    @objc optional func controlEvent(_ sender: Any?, event: Any?) -> (Void)
}
/******************************************************/

public typealias OnControlEvent = (ControlEvent, Any?) -> (Void)
public typealias OnQueryControlEvent = (Any?) -> (ControlEvent)
public typealias OnControlEventEscaping = (Any?, @escaping OnQueryControlEvent) -> (Void)

/******************************************************/
public typealias ControlEventEnumiratedString = (Int, String?)

@objc public enum ControlEventDataType: Int {
    case none = -1, bool = 1, int = 2, string = 3, enumiratedString = 4, object = 21
}
public enum ControlEvent {
    case none, bool(Bool?), int(Int?), string(String?), enumiratedString(Int, String?), object(Any?)

    public var type: ControlEventDataType {
        switch self {
        case .bool: return .bool
        case .int: return .int
        case .string: return .string
        case .enumiratedString: return .enumiratedString
        case .object: return .object
        default: return .none
        }
    }
    public var value: (ControlEventDataType, Any?)? {
        switch self {
        case .bool(let _value): return (ControlEventDataType.bool, _value)
        case .int(let _value): return (ControlEventDataType.int, _value)
        case .string(let _value): return (ControlEventDataType.string, _value)
        case .enumiratedString(let _index, let _value): return (ControlEventDataType.enumiratedString, (_index, _value))
        case .object(let _value): return (ControlEventDataType.object, _value)
        default: return (ControlEventDataType.none, nil)
        }
    }
}
/******************************************************/
