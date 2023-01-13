import Foundation

@objc open class CustomTableViewPagesDataResult: CustomListDataResult {
    public var pageIndex: Int = -1
    public var pageCount: Int = -1
    public var listCount: Int = -1
    public var loadTrigger: Int = 5

    
    enum CodingKeys: String, CodingKey {
        case pageIndex
        case pageCount
        case listCount
        case loadTrigger
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.pageIndex = try _container.decodeIfPresent(Int.self, forKey: .pageIndex) ?? 1
        self.pageCount = try _container.decodeIfPresent(Int.self, forKey: .pageCount) ?? 1
        self.listCount = try _container.decodeIfPresent(Int.self, forKey: .listCount) ?? 1
        self.loadTrigger = try _container.decodeIfPresent(Int.self, forKey: .loadTrigger) ?? self.loadTrigger
    }
    
    public required init(data: NSDictionary?) {
        super.init(data: data)
        guard let _data = data else { return }
        self.pageIndex = _data["pageIndex"] as? Int ?? 0
        self.pageCount = _data["pageCount"] as? Int ?? 0
        self.listCount = _data["listCount"] as? Int ?? 0
        self.loadTrigger = _data["loadTrigger"] as? Int ?? self.loadTrigger
    }
}
