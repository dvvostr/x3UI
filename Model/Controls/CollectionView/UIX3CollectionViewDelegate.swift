import UIKit

@objc public protocol UIX3CollectionViewDelegate {
    @objc optional func collectionView(setupFor collectionView: UIX3CollectionView)
    @objc optional func collectionView(numberOfSectionsOf collectionView: UIX3CollectionView) -> Int
    @objc optional func collectionView(_ collectionView: UIX3CollectionView, numberOfRowsInSection section: Int) -> Int

    @objc optional func collectionView(_ collectionView: UIX3CollectionView, rowForIndexPath indexPath: IndexPath) -> UIX3CustomCollectionCell.Type
    @objc optional func collectionView(_ collectionView: UIX3CollectionView, layout: UICollectionViewLayout, sizeForCollectionCellAt indexPath: IndexPath) -> CGSize
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    @objc optional func collectionView(_ collectionView: UIX3CollectionView, indexPath: IndexPath, collectionCellDidLoad cell: UICollectionViewCell?)
    @objc optional func collectionView(_ collectionView: UIX3CollectionView, willDisplay cell: UICollectionViewCell, forRowAt indexPath: IndexPath)


    @objc optional func collectionView(headerViewFor collectionView: UIX3CollectionView
) -> UIX3CustomCollectionHeaderFooterView.Type
    @objc optional func collectionView(_ collectionView: UIX3CollectionView, heightForCollectionHeaderInSection section: Int) -> CGFloat
    @objc optional func collectionView(_ collectionView: UIX3CollectionView, section: Int, collectionHeaderDidLoad view: UIView?)
}
