import UIKit

@objc @IBDesignable open class CustomTopButtomPanelListView: UIX3CustomView {
    public struct Defaults {
        public struct Color {
        }
        public static var topViewHeight: CGFloat = 52.0
        public static var bottomViewHeight: CGFloat = 52.0
        public static var panelDuration: CGFloat = 0.3
    }
    
    public struct PanelOptions : OptionSet {
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static var top: CustomTopButtomPanelListView.PanelOptions {
            get { return CustomTopButtomPanelListView.PanelOptions(rawValue: 1 << 0) }
        }
        public static var bottom: CustomTopButtomPanelListView.PanelOptions {
            get { return CustomTopButtomPanelListView.PanelOptions(rawValue: 1 << 1) }
        }
        public static var none: CustomTopButtomPanelListView.PanelOptions {
            get { return [] }
        }
        public static var all: CustomTopButtomPanelListView.PanelOptions {
            get { return [.top, .bottom] }
        }
        func elements() -> AnySequence<Self> {
            var remainingBits = rawValue
            var bitMask: RawValue = 1
            return AnySequence {
                return AnyIterator {
                    while remainingBits != 0 {
                        defer { bitMask = bitMask &* 2 }
                        if remainingBits & bitMask != 0 {
                            remainingBits = remainingBits & ~bitMask
                            return Self(rawValue: bitMask)
                        }
                    }
                    return nil
                }
            }
        }
    }
    public lazy var topView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIX3CustomControl.Defaults.Color.background
        return _view
    }()
    public lazy var bottomView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIX3CustomControl.Defaults.Color.background
        return _view
    }()
    public lazy var tableView: UIX3TableView = {
        let _view = UIX3TableView()
        _view.backgroundColor = UIX3CustomControl.Defaults.Color.background
        return _view
    }()
    
    public var panelOptions: CustomTopButtomPanelListView.PanelOptions = [] {
        didSet { self.invalidate() }
    }
    private var _topViewOffset: CGFloat = 0
    @IBInspectable public var topViewHeight: CGFloat = CustomTopButtomPanelListView.Defaults.topViewHeight{
        didSet { self.invalidate() }
    }
    @IBInspectable public var bottomViewHeight: CGFloat = CustomTopButtomPanelListView.Defaults.bottomViewHeight{
        didSet { self.invalidate() }
    }
    private weak var topViewTopConstraint: NSLayoutConstraint?
    private weak var topViewHeightConstraint: NSLayoutConstraint?
    private weak var bottomViewBottomConstraint: NSLayoutConstraint?
    private weak var bottomViewHeightConstraint: NSLayoutConstraint?

    public var tableViewDelegate: UIX3TableViewDelegate? {
        didSet {
            self.tableView.tableViewDelegate = self
        }
    }

    open override func setupView() {
        super.setupView()
        self.topView.alpha = 0
        self.addSubview(topView)
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomView.alpha = 0
        self.addSubview(bottomView)
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.tableViewDelegate = self
        
        self.topViewTopConstraint = topView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        self.topViewHeightConstraint = topView.heightAnchor.constraint(equalToConstant: self.topViewHeight)
        NSLayoutConstraint.activate([
            self.topViewTopConstraint!,
            self.topView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.topView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.topViewHeightConstraint!
        ])

        self.bottomViewBottomConstraint = bottomView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        self.bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: self.bottomViewHeight)
        NSLayoutConstraint.activate([
            self.bottomViewBottomConstraint!,
            self.bottomView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.bottomView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.bottomViewHeightConstraint!
        ])
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 0),
            self.tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
        ])
        self.showTopView(force: true)
        self.showButtonView(force: true)
    }
    public override func invalidate() {
        self.topViewHeightConstraint?.constant = self.topViewHeight
        if self.topViewTopConstraint?.constant ?? 0 > 0 {
            self.topViewTopConstraint?.constant = self.topViewHeight
        }
    }
}

extension CustomTopButtomPanelListView: UIX3TableViewDelegate {
    public func tableView(setupFor tableView: UIX3TableView) {
        self.tableViewDelegate?.tableView?(setupFor: tableView)
    }
    public func tableView(_ tableView: UIX3TableView, rowForSection section: Int) -> UITableViewCell.Type {
        return self.tableViewDelegate?.tableView?(tableView, rowForSection: section) ?? UITableViewCell.self
    }
    public func tableView(_ tableView: UIX3TableView, heightForTableRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewDelegate?.tableView?(tableView, heightForTableRowAt: indexPath) ?? 0
    }

    public func tableView(_ tableView: UIX3TableView, indexPath: IndexPath, tableCellDidLoad cell: UITableViewCell?) {
        self.tableViewDelegate?.tableView?(tableView, indexPath: indexPath, tableCellDidLoad: cell)
    }
    public func tableView(_ tableView: UIX3TableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableViewDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    public func tableView(_ tableView: UIX3TableView, needNewPage page: Int) {
        self.tableViewDelegate?.tableView?(tableView, needNewPage: page)
    }
    public func tableView(headerViewFor tableView: UIX3TableView) -> UIX3CustomTableHeaderFooterView.Type {
        return self.tableViewDelegate?.tableView?(headerViewFor: tableView) ?? UIX3CustomTableHeaderFooterView.self
    }
    public func tableView(_ tableView: UIX3TableView, heightForTableHeaderInSection section: Int) -> CGFloat {
        return self.tableViewDelegate?.tableView?(tableView, heightForTableHeaderInSection: section) ?? 0
    }
    public func tableView(_ tableView: UIX3TableView, section: Int, tableHeaderDidLoad view: UIView?) {
        self.tableViewDelegate?.tableView?(tableView, section: section, tableHeaderDidLoad: view)
    }
    public func tableView(_ tableView: UIX3TableView, scrollDitection: UIX3TableViewScrollDirection, from startPosition: CGFloat, on position: CGFloat, diffScroll: CGFloat) {
        self.tableViewDelegate?.tableView?(tableView, scrollDitection: scrollDitection, from: startPosition, on: position, diffScroll: diffScroll)
        if self.canAnimateTopView(tableView) && (tableView.contentOffset.y - (self.tableView.tableHeaderView?.frame.height ?? 0)) >= self.topViewHeight {
            var _height = self._topViewOffset
            if self.tableView.scrollDirection == .scrollDown {
                _height = max(0, self._topViewOffset - abs(diffScroll))
            } else if self.tableView.scrollDirection == .scrollUp {
                _height = min(self.topViewHeight, self._topViewOffset + abs(diffScroll))
            }
            if _height != self._topViewOffset  && (
                (tableView.scrollDirection == .scrollUp && _height != 0) ||
                (tableView.scrollDirection == .scrollDown && _height < self.topViewHeight)
            ){
                self._topViewOffset = _height
                self.updateHeader()
                self.topView.alpha = _height > 0 ? 1 : 0
                self.topViewTopConstraint?.constant = _height
            }
        }
        if self.panelOptions.elements().contains(.bottom) {
            guard let _height = self.bottomViewHeightConstraint?.constant else { return }
            if scrollDitection == .scrollUp && (startPosition - position) > (_height / 2) {
                self.showButtonView()
            } else if scrollDitection == .scrollDown && (position - startPosition) > (_height / 2) {
                self.hideButtonView()
            }
        }
    }
    public func tableView(_ tableView: UIX3TableView, endScroll position: CGFloat) {
        self.tableViewDelegate?.tableView?(tableView, endScroll: position)
        let _range = self.topViewHeight - 0
        if self._topViewOffset > (0 + (_range / 2)) {
            self.showTopView()
        } else {
            self.hideTopView()
        }
    }
}
extension CustomTopButtomPanelListView {
    private func canAnimateTopView(_ tableView: UIX3TableView) -> Bool {
        if !self.panelOptions.elements().contains(.top)
//            self.topView.subviews.count == 0 ||
            { return false }
        return true
    }
    private func canAnimateBottomView(_ scrollView: UIScrollView) -> Bool {
//        return self.footerFilterView != nil && [0, 2].contains(self.viewType.rawValue) &&
//            scrollView.contentOffset.y > 0 &&
//            abs(scrollView.contentOffset.y - self._scrollPosition) > 20
        return true
    }
    private func showTopView(duration: CGFloat = CustomTopButtomPanelListView.Defaults.panelDuration, force: Bool = false) {
        self.layoutIfNeeded()
        if !force && self.tableView.items?.items.count ?? 0 == 0 { return }
        if self.topViewTopConstraint?.constant != self.topViewHeightConstraint?.constant {
            self.topViewTopConstraint?.constant = (self.topViewHeightConstraint?.constant ?? 0)
            UIView.animate(withDuration: force ? 0 : duration, animations: {
                self.topView.alpha = 1
                self.layoutIfNeeded()
            }, completion: { _ in
                self._topViewOffset = self.topViewHeight
            })
        }
    }
    private func hideTopView(duration: CGFloat = CustomTopButtomPanelListView.Defaults.panelDuration, force: Bool = false) {
        self.layoutIfNeeded()
        if (self.tableView.items?.elementCount ?? 0 > 0 && self.tableView.items?.elementCount ?? -1 < 8 && !force) { return }
        if self.topViewTopConstraint?.constant != 0 {
            self.topViewTopConstraint?.constant = 0
            UIView.animate(withDuration: duration, animations: {
                self.topView.alpha = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self._topViewOffset = 0
            })
        }
    }
    private func showButtonView(force: Bool = false) {
        self.layoutIfNeeded()
        if (!force) && (self.tableView.items?.items.count ?? 0 == 0 || self.tableView.scrollDirection == .scrollDown) { return }
        if self.bottomViewBottomConstraint?.constant != self.bottomViewHeightConstraint?.constant {
            self.bottomViewBottomConstraint?.constant = -(self.bottomViewHeightConstraint?.constant ?? 0)
            UIView.animate(withDuration: CustomTopButtomPanelListView.Defaults.panelDuration, animations: {
                self.bottomView.alpha = 1
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    private func hideButtonView(_ force: Bool = false) {
        self.layoutIfNeeded()
        if (self.tableView.items?.elementCount ?? 0 > 0 && self.tableView.items?.elementCount ?? -1 < 8 && !force) { return }
        if self.bottomViewBottomConstraint?.constant != 0 {
            self.bottomViewBottomConstraint?.constant = 0
            UIView.animate(withDuration: CustomTopButtomPanelListView.Defaults.panelDuration, animations: {
                self.bottomView.alpha = 0
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    private func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }

    public func updateHeader() {
    }
    
    public func updateFooter() {
        
    }
}
