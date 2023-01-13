import UIKit

// MARK: CGPoint extension

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDist = self.x - point.x
        let yDist = self.y - point.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    func farCornerDistance() -> CGFloat {
        let bounds = UIScreen.main.bounds
        let leftTopCorner = CGPoint.zero
        let rightTopCorner = CGPoint(x: bounds.width, y: 0)
        let leftBottomCorner = CGPoint(x: 0, y: bounds.height)
        let rightBottomCorner = CGPoint(x: bounds.width, y: bounds.height)
        return max(distance(to: leftTopCorner), max(distance(to: rightTopCorner), max(distance(to: leftBottomCorner), distance(to: rightBottomCorner))))
    }
}
