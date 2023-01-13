import Foundation

@objc open class CustomSelectedListDataResult: CustomListDataResult {
    enum CodingKeys: String, CodingKey {
        case items
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try _container.decodeIfPresent([CustomSelectedListDataSection].self, forKey: .items) ?? Array()
    }
    public required init(data: NSDictionary?) {
        super.init(data: nil)
        for _item in data?["items"] as? NSArray ?? [] {
            self.items.append(CustomSelectedListDataSection(data: _item as? NSDictionary))
        }
    }
    open override func section<T>(_ section: Int) -> T? where T : CustomListDataSection {
        if self.items.indices.contains(section) {
            return items[section] as? T
        } else {
            return nil
        }
    }
}
@objc open class CustomSelectedListDataSection: CustomListDataSection {
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try _container.decodeIfPresent([CustomSelectedListDataItem].self, forKey: .items) ?? Array()
    }
    public required init(data: NSDictionary?) {
        super.init(data: data)
        self.items.removeAll()
        for _item in data?["items"] as? NSArray ?? [] {
            self.items.append(CustomSelectedListDataItem(data: _item as? NSDictionary))
        }
    }
    open override func item<T>(_ item: Int) -> T? where T : CustomListDataItem {
        if self.items.indices.contains(item) {
            return items[item] as? T
        } else {
            return nil
        }
    }
}
@objc open class CustomSelectedListDataItem: CustomListDataItem {
    @objc public var isSelected: Bool = false
    @objc public var isExpanded: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case isSelected
        case isExpanded
    }
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.isSelected = try ((_container.decodeIfPresent(Int.self, forKey: .isSelected) ?? 0) == 1)
        self.isExpanded = try ((_container.decodeIfPresent(Int.self, forKey: .isExpanded) ?? 0) == 1)
    }
    public required init(data: NSDictionary?) {
        super.init(data: data)
        self.isSelected = (data?["isSelected"] as? Int ?? 0) == 1
        self.isExpanded = (data?["isExpanded"] as? Int ?? 0) == 1
    }
   
}


