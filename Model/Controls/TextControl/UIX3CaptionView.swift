import UIKit

@IBDesignable open class UIX3CaptionView: UIX3CustomView {
    // MARK: ******* Defaults *******
        public struct Defaults {
            public struct Color {
            }
            public static var captionInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            public static var viewInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        }
    // See *UX3CustomControl.Defaults*
    // MARK: ************ Initialize & invalidate ************
    deinit {
        removeObservers()
    }
    open override func setupView() {
        super.setupView()
        self.setupObservers()
        self.addSubview(captionLabel)
    }
    open override func invalidate() {
        super.invalidate()
        self.invalidateCaptionView(frame: self.bounds)
        self.view?.invalidate()
    }
    private func invalidateCaptionView(frame: CGRect) {
        self.captionLabel.frame = CGRect(x: self.captionInsets.left, y: self.captionInsets.top, width: frame.width - (self.captionInsets.left + self.captionInsets.right), height: self.font?.lineHeight ?? 16)
        let _viewTop = self.captionLabel.frame.y + self.captionLabel.frame.height + self.captionInsets.bottom + self.viewInsets.top
        self.view?.frame = CGRect(x: self.viewInsets.left, y: _viewTop, width: frame.width - (self.viewInsets.left + self.viewInsets.right), height: frame.height - (_viewTop + self.viewInsets.bottom))
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateCaptionView(frame: self.bounds)
        self.view?.invalidate()
    }
    open func setupObservers() {
        _observations.append(self.captionLabel.observe(\UILabel.font, options: [.initial, .new]) { [weak self] (_textView, _change) in
            guard let _self = self else { return }
            _self.invalidate()
        })
    }
    private func removeObservers() {
        _observations.forEach { $0.invalidate() }
        _observations.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
// MARK: ************ Private variabled & controls ************
    private var _observations: [NSKeyValueObservation] = []
// MARK: ************ Public propertyes ************
    open var view: UIX3CustomView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let _view = self.view {
                self.addSubview(_view)
            }
            self.invalidate()
        }
    }
    public lazy var captionLabel: UILabel = {
        let _view = UILabel()
        _view.font = UIX3CustomControl.Defaults.textFont
        _view.textColor = UIX3CustomControl.Defaults.Color.text
        _view.text = "Caption".localized
        return _view
    }()
    @IBInspectable public var caption: String? {
        didSet {
            self.captionLabel.text = self.caption
        }
    }
    @IBInspectable public var font: UIFont? {
        didSet {
            self.captionLabel.font = self.font
        }
    }
    public var captionInsets: UIEdgeInsets = UIX3CaptionView.Defaults.captionInsets {
        didSet {
            self.invalidate()
        }
    }
    public var viewInsets: UIEdgeInsets = UIX3CaptionView.Defaults.viewInsets {
        didSet {
            self.invalidate()
        }
    }
}

extension UIX3CaptionView: UITextViewDelegate {
    
}
