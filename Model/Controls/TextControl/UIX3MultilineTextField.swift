import Foundation
import UIKit

/// Text field with support for multiple lines.
/// - NOTE: Under the hood this is just a `UITextView` which aims to provide
///   many of the functionalities currently available in the `UITextField` class.
///   Currently the following functionalities are supported:
/// + Multiple lines
/// + Customizable left view
/// + Customizable placeholder
///
/// - TODO: The following features are still missing:
/// + Add support for displaying a right view
/// + Configure when left/right views will be shown using `UITextField.leftViewMode`
public class UIX3MultilineTextField: UITextView {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
// MARK: ************ Initialize & invalidate ************
    public override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        _placeholderView = UITextView(frame: frame, textContainer: textContainer)
        super.init(frame: frame, textContainer: textContainer)
        self.initialize()
    }
    func initialize() {
        self.textContainer.lineFragmentPadding = 0
        
        self.insertSubview(_placeholderView, at: 0)
        _placeholderView.frame = self.bounds
        _placeholderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        _placeholderView.text = ""
        _placeholderView.isEditable = false
        _placeholderView.textColor = UIColor(white: 0.7, alpha: 1)
        _placeholderView.backgroundColor = .clear
        // observe `UITextView` property changes to react accordinly
        #if swift(>=4.2)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(notification:)), name: UITextView.textDidChangeNotification, object: self )
        #else
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(notification:)), name: Notification.Name.UITextViewTextDidChange, object: self)
        #endif
        
        _fieldObservations.append(
            self.observe(\.font, options: [.initial, .new]) { [weak self] (_textField, _change) in
                self?._placeholderView.font = _textField.font
            }
        )
        _fieldObservations.append(
            self.observe(\.textContainerInset, options: [.initial, .new]) { [weak self] (_textField, _change) in
                guard let _self = self else { return }
                _self._placeholderView.textContainerInset = _textField.textContainerInset
                _self.invalidateLeftView()
            }
        )
        _fieldObservations.append(
            self.textContainer.observe(\.lineFragmentPadding, options: [.initial, .new]) { [weak self] (_textContainer, _changes) in
                self?._placeholderView.textContainer.lineFragmentPadding = _textContainer.lineFragmentPadding
            }
        )
    }
    public required init?(coder aDecoder: NSCoder) {
        _placeholderView = UITextView()
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
    private func invalidateLeftView() {
        if let path = self.leftExclusionPath {
            remove(exlusionPath: path)
        }
        if let view = self.leftView {
            let size = view.bounds.size
            let frame = CGRect(origin: leftViewOrigin, size: size)
            view.frame = frame
            let exclusionRect = CGRect(origin: CGPoint(x: leftViewOrigin.x - textContainerInset.left, y: leftViewOrigin.y - textContainerInset.top), size: CGSize(width: size.width + 8, height: size.height))
//            let exclusionPath = UIBezierPath(rect: exclusionRect)

//            let exclusionRect = CGRect(origin: CGPoint(x: -20, y: -20), size: size)
            let exclusionPath = UIBezierPath(rect: exclusionRect)

            add(exclusionPath: exclusionPath)
            
            self.leftExclusionPath = exclusionPath
        }
    }
// MARK: ************ Private variabled & controls ************
    
    private var _fieldObservations: [NSKeyValueObservation] = []
    private let _placeholderView: UITextView

    
// MARK: ************ Properties ************
    public override var text: String! {
        didSet {
            self.handleTextViewDidChange(self)
        }
    }
    public override var attributedText: NSAttributedString! {
        didSet {
            self.handleTextViewDidChange(self)
        }
    }
    @IBInspectable public var placeholder: String? {
        didSet {
            _placeholderView.text = placeholder
        }
    }
    public var placeholderColor: UIColor = .black {
        didSet {
            _placeholderView.textColor = placeholderColor
        }
    }
    public var placeholderAlignment: NSTextAlignment = .left {
        didSet {
            _placeholderView.textAlignment = placeholderAlignment
        }
    }
    public var isPlaceholderScrollEnabled: Bool = false {
        didSet {
            _placeholderView.isScrollEnabled = isPlaceholderScrollEnabled
        }
    }
    public var leftViewOrigin: CGPoint = CGPoint(x: 8, y: 6) {
        didSet { invalidateLeftView() }
    }
    
    private var leftExclusionPath: UIBezierPath?
    
    
    /// Convenience property to set an image directly instead of a left view
    @IBInspectable
    public var leftImage: UIImage? {
        get {
            return (self.leftView as? UIImageView)?.image
        }
        set {
            if let image = newValue {
                self.leftView = UIImageView(image: image)
            }
            else {
                self.leftView = nil
            }
        }
    }
    
    /// The overlay view displayed in the left side of the text field.
    public var leftView: UIView? {
        willSet {
            if let view = self.leftView {
                view.removeFromSuperview()
            }
        }
        didSet {
            if let view = self.leftView {
                self.addSubview(view)
            }
            
            invalidateLeftView()
        }
    }
    
    
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            removeObservers()
        }
    }
    

    
    
    @objc private func textViewDidChange(notification: Notification) {
        guard let textView = notification.object as? UIX3MultilineTextField else {
            return
        }
        
        handleTextViewDidChange(textView)
    }
// MARK: ************ Private methods ************
    @objc private func handleTextViewDidChange(_ textView: UIX3MultilineTextField) {
        _placeholderView.isHidden = !textView.text.isEmpty
            || !textView.attributedText.string.isEmpty
        
        // handling scrolling of placeholder view
        _placeholderView.setContentOffset(.zero, animated: false)
        
        if let left = leftView {
            if _placeholderView.isHidden {
                self.addSubview(left)
            }
            else {
                _placeholderView.addSubview(left)
            }
        }
    }
    private func add(exclusionPath: UIBezierPath) {
        self.textContainer.exclusionPaths.append(exclusionPath)
        _placeholderView.textContainer.exclusionPaths.append(exclusionPath)
    }
    private func remove(exlusionPath: UIBezierPath) {
        #if swift(>=5)
        if let index = self.textContainer.exclusionPaths.firstIndex(of: exlusionPath) {
            self.textContainer.exclusionPaths.remove(at: index)
        }
        
        if let index = _placeholderView.textContainer.exclusionPaths.firstIndex(of: exlusionPath) {
            _placeholderView.textContainer.exclusionPaths.remove(at: index)
        }
        #else
        if let index = self.textContainer.exclusionPaths.index(of: exlusionPath) {
            self.textContainer.exclusionPaths.remove(at: index)
        }
        
        if let index = placeholderView.textContainer.exclusionPaths.index(of: exlusionPath) {
            _placeholderView.textContainer.exclusionPaths.remove(at: index)
        }
        #endif
    }
}
