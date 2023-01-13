import UIKit
import x3Core
import SwiftUI

@objc public enum UIX3TableViewScrollDirection: Int {
    case none = 0
    case scrollDown = 1
    case scrollUp = 2
    case scrollLock = 3
}
public struct CGFloatMinMax {
    public var min: CGFloat = 0
    public var max: CGFloat = 0
}

@objc open class UIX3TableView: UITableView {
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
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setupView()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    open func setupView(){
        self.setupTableView()
    }

    @objc public var items: CustomListDataResult? {
        didSet {
            self.reloadData()
        }
    }
// MARK: ************ Public methods ************
    open override func reloadData() {
        super.reloadData()
    }
    public final func lockLoad() {
        self._isLockLoad = true
    }
    public final func unlockLoad() {
        self._isLockLoad = false
    }
// MARK: ************ Private propertyes ************
    private var _isUpdate: Bool = false
    private var _isLockLoad: Bool = false

    private var _scrollOffset: CGFloat = 0
    private var _scrollPosition: CGFloat = 0
    private var _scrollViewHeight: CGFloat = 0
    
    private var _topViewHeightValues: CGFloatMinMax = CGFloatMinMax(min: 0, max: 52)
    private var _bottomViewHeightValues: CGFloatMinMax = CGFloatMinMax(min: 0, max: 52)
// MARK: ************ Public propertyes ************
    public var scrollDirection: UIX3TableViewScrollDirection = .scrollDown

    public var tableViewDelegate: UIX3TableViewDelegate? {
        didSet {
            self.setupTableView()
            self.tableViewDelegate?.tableView?(setupFor: self)
        }
    }
    public var isUpdate: Bool {
        get { return self._isUpdate }
    }
    public var isLockLoad: Bool {
        get { return self._isLockLoad }
    }
    public var scrollOffset: CGFloat {
        get { return self._scrollOffset }
    }
    public var scrollPosition: CGFloat {
        get { return self._scrollPosition }
    }

}
extension UIX3TableView {
    public func setupTableView() {
        self.dataSource = self
        self.delegate = self
        self.registerClass(UIX3TableViewCustomCell.self)
        self.alwaysBounceVertical = false
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 15, *) {
            self.sectionHeaderTopPadding = 0
        }
        self.separatorStyle = .none
        self.separatorColor = UIColor.clear
    }
}
extension UIX3TableView: UITableViewDataSource, UITableViewDelegate {
    public func defaultCell(for indexPath: IndexPath) -> UIX3TableViewCustomCell {
        let _cell: UIX3TableViewCustomCell = self.dequeueReusableCellForIndexPath(indexPath)
        return _cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return (self.items?.items.count ?? 0)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.items?.items.indices.contains(section) ?? false) ? (self.items?.items[section].items.count ?? 0) : 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var _cell: UITableViewCell
        if let _class = self.tableViewDelegate?.tableView?(self, rowForSection: indexPath.section) {
            _cell = tableView.dequeueReusableCell(withIdentifier: String(describing: _class.self), for: indexPath)
        } else {
            _cell = self.defaultCell(for: indexPath)
        }
        self.tableViewDelegate?.tableView?(self, indexPath: indexPath, tableCellDidLoad: _cell)
        return _cell
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewDelegate?.tableView?(self, heightForTableRowAt: indexPath) ?? UIX3TableView.Defaults.rowHeight
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _view = tableView as? UIX3TableView {
            self.tableViewDelegate?.tableView?(_view, willDisplay: cell, forRowAt: indexPath)
            if let _items = self.items as? CustomTableViewPagesDataResult, !self.isLockLoad && self.scrollDirection == .scrollDown && _items.pageIndex <  _items.pageCount && _view.indexPathToIndex(value: indexPath) >= (_view.totalRows() - _items.listCount + _items.loadTrigger) {
                self.lockLoad()
                self.tableViewDelegate?.tableView?(self, needNewPage: _items.pageIndex + 1)
            }
        }
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableViewDelegate?.tableView?(self, heightForTableHeaderInSection: section) ?? UIX3TableView.Defaults.headerHeight
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var _class = UITableViewHeaderFooterView.self
        if let _obj = self.tableViewDelegate?.tableView?(headerViewFor: self) {
            _class = _obj
        }
        let _view = self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: _class.self))
        self.tableViewDelegate?.tableView?(self, section: section, tableHeaderDidLoad: _view)
        return _view
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _contentOffset = scrollView.contentOffset.y < 0 ? 0 : scrollView.contentOffset.y
        defer {
            self._scrollViewHeight = scrollView.contentSize.height
            self._scrollOffset = _contentOffset
        }
        let _diffHeight = scrollView.contentSize.height - self._scrollViewHeight
        let _diffScroll = scrollView.contentOffset.y - self._scrollOffset
        guard _diffHeight == 0 else { return }
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        self.scrollDirection = (_diffScroll > 0 && scrollView.contentOffset.y > absoluteTop) ? .scrollDown : (_diffScroll < 0 && scrollView.contentOffset.y < absoluteBottom) ? .scrollUp : .none
        
        self.tableViewDelegate?.tableView?(self, scrollDitection: self.scrollDirection, from: self._scrollPosition, on: _contentOffset, diffScroll: _diffScroll)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self._scrollPosition = scrollView.contentOffset.y
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
//        } else {
//            self.animateFooter()
        }
    }
    
    func scrollViewDidStopScrolling() {
        self.tableViewDelegate?.tableView?(self, endScroll: self._scrollPosition)
    }
}
