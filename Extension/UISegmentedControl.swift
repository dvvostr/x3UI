import UIKit

public extension UISegmentedControl {
    func fixBackgroundSegmentControl(){
        if #available(iOS 13.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(self.numberOfSegments-1)  {
                    let _view = self.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    _view.isHidden = true
                }
            }
        }
    }
}
