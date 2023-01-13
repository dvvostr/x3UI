import Foundation

typealias JSONData = [String: Decodable]

//typealias JSONData = String

@objc open class CustomDataResult: NSObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case dataType
    }
    public var dataType: Int = -1
    public func encode(to encoder: Encoder) throws {
        var _container = encoder.container(keyedBy: CodingKeys.self)
        try _container.encode(dataType, forKey: .dataType)
    }
    public override init() {
        super.init()
        clear()
    }

    public required init(from decoder: Decoder) throws {
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.dataType = try _container.decodeIfPresent(Int.self, forKey: .dataType) ?? -1
    }
    public required convenience init(data: NSDictionary?) {
        self.init()
        load(data: data)
    }
    open func clear() {
        self.dataType = -1
    }
    open func load(data: NSDictionary?) {
        self.clear()
        self.dataType = data?["dataType"] as? Int ?? -1
    }
}
