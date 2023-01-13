import UIKit
import x3Core

@IBDesignable
@objc open class UIX3GalleryCollectionView: UIX3CollectionView {
    public var currentVisibleIndexPath = IndexPath(row: 0, section: 0)
}


extension UIX3GalleryCollectionView {
    public  func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let _attributes =  collectionView.layoutAttributesForItem(at: currentVisibleIndexPath)
        let _newOriginForOldIndex = _attributes?.frame.origin
        return _newOriginForOldIndex ?? proposedContentOffset
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let _center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let _indexPath = self.indexPathForItem(at: _center) {
            currentVisibleIndexPath = _indexPath
        }
    }
}
