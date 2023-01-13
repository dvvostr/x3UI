import Foundation

@objc open class CustomListDataResult: CustomDataResult {
    public var items: [CustomListDataSection] = Array()
    enum CodingKeys: String, CodingKey {
        case items
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try _container.decodeIfPresent([CustomListDataSection].self, forKey: .items) ?? Array()
    }
    open func setupItems<T: CustomListDataSection>(itemType: T.Type, from decoder: Decoder) throws -> [T]  {
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        return try _container.decodeIfPresent([T].self, forKey: .items) ?? Array()
    }
    public required init(data: NSDictionary?) {
        super.init()
        self.items.removeAll()
        for _item in data?["items"] as? NSArray ?? [] {
            self.items.append(CustomListDataSection(data: _item as? NSDictionary))
        }
    }
    open func append(_ values: CustomListDataResult) {
        values.items.forEach({ _newSection in
            if let _section = self.items.filter({ $0.code == _newSection.code }).first {
                _section.add(section: _newSection)
            } else {
                self.items.append(_newSection)
            }
        })
    }
    open func section<T:CustomListDataSection>(_ section: Int) -> T? {
        if self.items.indices.contains(section) {
            return items[section] as? T
        } else {
            return nil
        }
    }

    open func item<T:CustomListDataItem>(_ indexPath: IndexPath) -> T? {
        if self.items.indices.contains(indexPath.section) && items[indexPath.section].items.indices.contains(indexPath.row) {
            return items[indexPath.section].items[indexPath.row] as? T
        } else {
            return nil
        }
    }

    open var itemCount: Int {
        get { return self.items.count }
    }
    open var elementCount: Int {
        get {
            return self.items.flatMap({
                return $0.items
            }).count
        }
    }
}
@objc open class CustomListDataSection: CustomDataResult {
    @objc public var code: String = ""
    @objc public var caption: String = ""
    @objc public var items: [CustomListDataItem] = Array()
//    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case caption
        case items
    }
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        if let _code = try _container.decodeIfPresent(String.self, forKey: .code) {
            self.code = _code
        } else if let _code = try _container.decodeIfPresent(Int.self, forKey: .code) {
            self.code = String(_code)
        }
//        self.code = try _container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.caption = try _container.decodeIfPresent(String.self, forKey: .caption) ?? ""
        self.items = try _container.decodeIfPresent([CustomListDataItem].self, forKey: .items) ?? Array()
    }
    public required init(data: NSDictionary?) {
        super.init()
        self.items.removeAll()
        self.code = data?["code"] as? String ?? ""
        self.caption = data?["caption"] as? String ?? ""
        for _item in data?["items"] as? NSArray ?? [] {
            self.items.append(CustomListDataItem(data: _item as? NSDictionary))
        }
    }
    open var itemCount: Int {
        get { return self.items.count }
    }
    open func item<T:CustomListDataItem>(_ index: Int) -> T? {
        if self.items.indices.contains(index) {
            return items[index] as? T
        } else {
            return nil
        }
    }
    open func add(section: CustomListDataSection?) {
        section?.items.forEach({ _value in
            if self.items.filter({ $0.code == _value.code }).first == nil {
                self.items.append(_value)
            }
        })
    }
}
@objc open class CustomListDataItem: CustomDataResult {
    @objc public var code: String = ""
    @objc public var caption: String = ""
    
    enum CodingKeys: String, CodingKey {
        case code
        case caption
    }
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let _container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try _container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.caption = try _container.decodeIfPresent(String.self, forKey: .caption) ?? ""
    }
    public required init(data: NSDictionary?) {
        super.init()
        self.code = data?["code"] as? String ?? ""
        self.caption = data?["caption"] as? String ?? ""
    }
}

