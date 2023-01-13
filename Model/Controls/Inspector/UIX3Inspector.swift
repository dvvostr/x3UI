import UIKit
import x3Core

public class UIX3Inspector: UIView {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
// MARK: ************ Initialize & invalidate ************
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    open func initialize() {
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    deinit {
        removeObservers()
    }
    private func removeObservers() {
        _fieldObservations.forEach { $0.invalidate() }
        _fieldObservations.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
// MARK: ************ Private variabled & controls ************
    
    private var _fieldObservations: [NSKeyValueObservation] = []
    
// MARK: ************ Properties ************

// MARK: ************ Private methods ************
}
