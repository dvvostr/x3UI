import UIKit
import x3Core

// https://medium.com/swift2go/implementing-a-dynamic-height-uicollectionviewcell-in-swift-5-bdd912acd5c8

@objc open class UIX3CollectionView: UICollectionView {
// MARK: ******* Defaults *******
    public struct Defaults {
        public struct Color {
        }
        public static var rowHeight: CGFloat = 48
        public static var headerHeight: CGFloat = 36
        public static var footerHeight: CGFloat = 36
    }
// See *UX3CustomControl.Defaults*
// MARK: ************ Initialize & invalidate ************
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self._layout)
        self.setupView()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    open func setupView() {
        self.setupCollectionView()
    }
// MARK: ************ Public methods ************
    open override func reloadData() {
        super.reloadData()
    }
    open func registerNib<T: UICollectionViewCell>(_: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: String(describing: T.self), bundle: bundle ?? Bundle(for: T.self))
        self.register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
    open func registerClass<T: UICollectionViewCell>(_: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
// MARK: ************ Public propertyes ************
    open var items: CustomListDataResult? {
        didSet{
            self.reloadData()
        }
    }
// MARK: ************ Private methods ************
    private let _layout = UIX3StickyHeaderLayout()
// MARK: ************ Private propertyes ************
    public var collectionViewDelegate: UIX3CollectionViewDelegate? {
        didSet {
            self.setupCollectionView()
            self.collectionViewDelegate?.collectionView?(setupFor: self)
        }
    }
}

extension UIX3CollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        self.dataSource = self
        self.delegate = self
        self.registerClass(UIX3CustomCollectionCell.self)
        self.alwaysBounceVertical = false
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let _i = self.collectionViewDelegate?.collectionView?(numberOfSectionsOf: self)
        guard let _count = self.collectionViewDelegate?.collectionView?(numberOfSectionsOf: self) else { return self.items?.items.count ?? 0}
        return _count
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _count = self.collectionViewDelegate?.collectionView?(self, numberOfRowsInSection: section) else { return self.items?.section(section)?.itemCount ?? 0}
        return _count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _class: UIX3CustomCollectionCell.Type = self.collectionViewDelegate?.collectionView?(self, rowForIndexPath: indexPath) ?? UIX3CustomCollectionCell.self
        let _cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: _class.self), for: indexPath)
        self.collectionViewDelegate?.collectionView?(self, indexPath: indexPath, collectionCellDidLoad: _cell)
        return _cell
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let _size = self.collectionViewDelegate?.collectionView?(self, layout: collectionViewLayout, sizeForCollectionCellAt: indexPath) else { return collectionViewLayout.collectionViewContentSize }
        return _size
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let _value = self.collectionViewDelegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) else { return 0 }
        return _value
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let _value = self.collectionViewDelegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) else { return 0 }
        return _value
    }
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let _size = self.collectionViewDelegate?.collectionView?(self, layout: collectionViewLayout, sizeForCollectionCellAt: indexPath) else { return collectionViewLayout.collectionViewContentSize }
//        return _size
//    }
    
    
}
//@objc optional func collectionView(_ collectionView: UIX3CollectionView, rowForSection section: Int) -> UICollectionViewCell.Type
//@objc optional func collectionView(_ collectionView: UIX3CollectionView, heightForCollectionRowAt indexPath: IndexPath) -> CGFloat
//@objc optional func collectionView(_ collectionView: UIX3CollectionView, indexPath: IndexPath, collectionCellDidLoad cell: UICollectionViewCell?)
//@objc optional func collectionView(_ collectionView: UIX3CollectionView, willDisplay cell: UICollectionViewCell, forRowAt indexPath: IndexPath)
//
//
//@objc optional func collectionView(headerViewFor collectionView: UIX3CollectionView
//) -> UIX3CustomCollectionHeaderFooterView.Type
//@objc optional func collectionView(_ collectionView: UIX3CollectionView, heightForCollectionHeaderInSection section: Int) -> CGFloat
//@objc optional func collectionView(_ collectionView: UIX3CollectionView, section: Int, tableHeaderDidLoad view: UIView?)
