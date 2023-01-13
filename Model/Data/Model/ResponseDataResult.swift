import Foundation

open class ResponseDataResult: NSObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case header
        case body
    }

    public var header: ResponseDataResultHeader

    func encode(to encoder: Encoder) throws {
        var _container = encoder.container(keyedBy: CodingKeys.self)
        try _container.encode(header, forKey: .header)
    }
    public required init(from decoder: Decoder) throws {
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.header = try _container.decode(ResponseDataResultHeader.self, forKey: .header)
//        self.body = try CustomDataResultBody(from: decoder)
    }

}

open class ResponseDataResultHeader: Codable {
    enum CodingKeys: String, CodingKey {
        case action
        case code
        case message
        case description = "desc"
    }

    public var action: String
    public var code: Int
    public var message: String
    public var description: String

    public func encode(to encoder: Encoder) throws {
        var _container = encoder.container(keyedBy: CodingKeys.self)
        try _container.encode(action, forKey: .action)
        try _container.encode(code, forKey: .code)
        try _container.encode(message, forKey: .message)
        try _container.encode(description, forKey: .description)
    }
    public required init(from decoder: Decoder) throws {
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.action = try _container.decodeIfPresent(String.self, forKey: .action) ?? ""
        self.code = try _container.decodeIfPresent(Int.self, forKey: .code) ?? 0
        self.message = try _container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.description = try _container.decodeIfPresent(String.self, forKey: .description) ?? ""
    }
}

open class CustomDataResultBody: Codable {
    enum CodingKeys: String, CodingKey {
        case type
//        case data
    }

    public var type: Int
//    public var data: Any?

    public func encode(to encoder: Encoder) throws {
        var _container = encoder.container(keyedBy: CodingKeys.self)
        try _container.encode(type, forKey: .type)
    }
    public required init(from decoder: Decoder) throws {
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try _container.decodeIfPresent(Int.self, forKey: .type) ?? -1
    }
}
