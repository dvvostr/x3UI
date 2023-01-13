import UIKit

open class UIX3XibView: UIView {
    private var _contentView: UIView?
    
    public var contentView: UIView! {
        get { return self._contentView }
    }
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    open func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        if self._contentView == nil {
            self.loadXib()
        }
    }
    func loadXib() {
        let _nibName = type(of: self).description().components(separatedBy: ".").last!
        let _nib = UINib(nibName: _nibName, bundle: Bundle(for: type(of: self)))
        self._contentView = _nib.instantiate(withOwner: self, options: nil).first as? UIView
        if let _view = self._contentView {
            _view.backgroundColor = UIColor.clear
            _view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(_view)
            NSLayoutConstraint.activate([
                _view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
                _view.topAnchor.constraint(equalTo: self.topAnchor),
                self.bottomAnchor.constraint(equalTo: _view.bottomAnchor)
                ])
        }
    }
    open class func loadFromNib<T: UIView>() -> T {
        return UINib(nibName: String(describing: T.self), bundle: Bundle.init(for: T.self)).instantiate(withOwner: nil, options: nil).first as! T
        
    }
    open class func loadOptionalFromNib<T: UIView>() -> T? {
        print(String(describing: T.self))
        return UINib(nibName: String(describing: T.self), bundle: Bundle.init(for: T.self)).instantiate(withOwner: nil, options: nil).first as? T
        
    }
    open class func create<T: UIView>(type: T.Type) -> T{
        return type.init()
    }
}

public class XibView: UIView {
    @IBOutlet var contentView: UIView!
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        loadXib()
    }
    
    func loadXib() {
        Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        guard let content = contentView else {
            return
        }
        //content.backgroundColor = .clear
        
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: content.trailingAnchor),
            content.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: content.bottomAnchor)
            ])
    }
}

