import UIKit

@objc public protocol UIX3TableViewDelegate {
    @objc optional func tableView(setupFor tableView: UIX3TableView)
    @objc optional func tableView(numberOfSectionsOf tableView: UIX3TableView) -> Int
    @objc optional func tableView(_ tableView: UIX3TableView, numberOfRowsInSection section: Int) -> Int

    @objc optional func tableView(_ tableView: UIX3TableView, rowForSection section: Int) -> UITableViewCell.Type
    @objc optional func tableView(_ tableView: UIX3TableView, heightForTableRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func tableView(_ tableView: UIX3TableView, indexPath: IndexPath, tableCellDidLoad cell: UITableViewCell?)
    @objc optional func tableView(_ tableView: UIX3TableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UIX3TableView, needNewPage page: Int)


    @objc optional func tableView(headerViewFor tableView: UIX3TableView) -> UIX3CustomTableHeaderFooterView.Type
    @objc optional func tableView(_ tableView: UIX3TableView, heightForTableHeaderInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UIX3TableView, section: Int, tableHeaderDidLoad view: UIView?)


    @objc optional func tableView(_ tableView: UIX3TableView, scrollDitection: UIX3TableViewScrollDirection, from startPosition: CGFloat, on position: CGFloat, diffScroll: CGFloat)
    @objc optional func tableView(_ tableView: UIX3TableView, endScroll position: CGFloat)
    
    @objc optional func tableView(_ tableView: UIX3TableView, items: CustomListDataResult?)
}
