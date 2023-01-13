import Foundation
import UIKit

public enum UITableViewScrollDirection {
    case none
    case scrollDown
    case scrollUp
    case scrollLock
}
public extension UITableView {
    private func sortIndexPathFunc(left: IndexPath, right: IndexPath) -> Bool {
        return (left.section == right.section && left.row < right.row) || (left.section < right.section)
    }
    var sortedVisibleIndexPath: [IndexPath]? {
        get {
            if let _rows = self.indexPathsForVisibleRows{
                return _rows.sorted(by: sortIndexPathFunc)
            } else {
                return nil
            }
        }
    }
    var firstVisible: IndexPath?{
        get{
            return self.sortedVisibleIndexPath?.first
        }
    }
    var nextFirstVisible: IndexPath?{
        get{
            return self.sortedVisibleIndexPath?.first(where: { $0 != self.firstVisible })
        }
    }
    var lastVisible: IndexPath?{
        get{
            return self.sortedVisibleIndexPath?.last
        }
    }
    var preLastVisible: IndexPath?{
        get{
            return self.sortedVisibleIndexPath?.last(where: { $0 != self.lastVisible })
        }
    }
    static func compareIndexPath ( item1: IndexPath?, item2: IndexPath? ) -> Bool {
        guard let _item1 = item1, let _item2 = item2 else { return false }
        return (_item1.section == item2?.section) && (_item1.item == _item2.item)
    }
    
    func registerNib<T: UITableViewCell>(_: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: String(describing: T.self), bundle: bundle ?? Bundle(for: T.self))
        self.register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func registerClass<T: UITableViewCell>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCellForIndexPath<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func registerNibForHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: String(describing: T.self), bundle: bundle ?? Bundle(for: T.self))
        self.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }
    
    func registerClassForHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) {
        self.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) -> T? {
        return self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T?
    }
    func resizeScrollToIndexPath(indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool = true){
        if (scrollPosition == .bottom && self.lastVisible == indexPath) ||
                (scrollPosition == .bottom && self.preLastVisible == indexPath) ||
                (scrollPosition == .top && self.firstVisible == indexPath) ||
                (scrollPosition == .top && self.nextFirstVisible == indexPath) {
            self.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        }
    }
    func totalRows() -> Int {
        var _total = 0
        if self.numberOfSections > 0 {
            for i in 0..<self.numberOfSections {
                _total += self.numberOfRows(inSection: i)
            }
        }
        return _total
    }
    func indexPathToIndex(value indexPath: IndexPath) -> Int {
        var _total = indexPath.row
        if self.numberOfSections > 0 {
            for i in 0..<indexPath.section {
                _total += self.numberOfRows(inSection: i)
            }
        }
        return _total
    }

    func scroll(to: UITableViewScrollDirection, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            if self.numberOfSections == 0 { return }
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .scrollUp:
                if numberOfRows > 0 {
                     let indexPath = IndexPath(row: 0, section: 0)
                     self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .scrollDown:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            default:
                break
            }
        }
    }
}
