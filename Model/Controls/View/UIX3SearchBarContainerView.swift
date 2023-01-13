import UIKit

public class UIX3SearchBarContainerView: UIView {

    public let searchBar: UISearchBar

    public init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)

        addSubview(searchBar)
    }

    public override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }

    required public init?(coder aDecoder: NSCoder) {
        self.searchBar = UISearchBar()
        super.init(coder: aDecoder)
        addSubview(self.searchBar)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
