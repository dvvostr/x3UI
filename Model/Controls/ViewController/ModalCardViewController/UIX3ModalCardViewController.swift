import UIKit
import x3Core

@IBDesignable open class UIX3ModalCardViewController: UIViewController {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
    public struct Defaults {
    }
// MARK: ************ Initialize & invalidate ************
    public enum CardViewState {
        case expanded
        case normal
        case compact
    }
    private var _viewState: CardViewState = .normal
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupView()
        self.setupWindow()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open func setupView() {
        self.setupWindow()
        self.window?.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
        self.view.insertSubview(self.bgView!, at: 0)
        self.bgView?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        self.bgView?.alpha = 0
        self.bgView?.fillSuperview()
        self.bgView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleBackgroundViewClick)))
        
        self.view.addSubview(self.cardView!)
        self.cardView?.translatesAutoresizingMaskIntoConstraints = false
        self.cardView?.clipsToBounds = true
        self.cardView?.layer.cornerRadius = 10.0
        self.cardView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.cardViewTopConstraint = self.cardView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30)
        NSLayoutConstraint.activate([
            cardViewTopConstraint!,
            self.cardView!.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.cardView!.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.cardView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])

        self.view.addSubview(self.handleView!)
        self.handleView?.translatesAutoresizingMaskIntoConstraints = false
        self.handleView?.clipsToBounds = true
        self.handleView?.layer.cornerRadius = 3.0
        NSLayoutConstraint.activate([
            self.handleView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            self.handleView!.bottomAnchor.constraint(equalTo: self.cardView!.topAnchor, constant: -10),
            self.handleView!.widthAnchor.constraint(equalToConstant: 50),
            self.handleView!.heightAnchor.constraint(equalToConstant: 6)
        ])

        if let safeAreaHeight = UIApplication.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.keyWindow?.safeAreaInsets.bottom {
            let _value = safeAreaHeight + bottomPadding
            cardViewTopConstraint?.constant = _value
        }
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        self.view.addGestureRecognizer(viewPan)
        self.cardPanStartingTopConstraint = cardViewTopConstraint?.constant ?? 0

        self.invalidate()
    }
    func setupWindow() {
        if isNotReady { return }
        
        self.parentWindow = UIApplication.keyWindow
        if let _scene = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).first as? UIWindowScene  {
            self.window = UIWindow(windowScene: _scene)
        } else {
            self.window = UIWindow(frame: (UIApplication.keyWindow?.bounds)!)
        }
        self.window?.frame = UIScreen.main.bounds
        self.window?.backgroundColor = .clear
        self.window?.windowLevel = UIWindow.Level.alert
        self.window?.rootViewController = self
    }
    var isNotReady: Bool {
        get {
            return UIApplication.keyWindow == nil
        }
    }
    open func invalidate() {

    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.invalidate()
    }
    deinit {
    }
// #MARK: ******* Handles *******
    @objc private func handleBackgroundViewClick() {
        self.hide()
    }
    private func handleAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha : CGFloat = 0.7
        guard let safeAreaHeight = UIApplication.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
              let bottomPadding = UIApplication.keyWindow?.safeAreaInsets.bottom else {
            return fullDimAlpha
        }
        let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
        let noDimPosition = safeAreaHeight + bottomPadding
        
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        if value > noDimPosition {
            return 0.0
        }
        
        return fullDimAlpha * 1 - ((value - fullDimPosition) / fullDimPosition)
    }
    @objc func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        if _viewState == .compact { return }
        let velocity = panRecognizer.velocity(in: self.view)
        let translation = panRecognizer.translation(in: self.view)
        
        switch panRecognizer.state {
        case .began:
            self.cardPanStartingTopConstant = cardViewTopConstraint?.constant ?? self.view.frame.height
        case .changed:
            if self.cardPanStartingTopConstraint + translation.y > 30.0 {
                self.cardViewTopConstraint?.constant = self.cardPanStartingTopConstant + translation.y
            }
            bgView?.alpha = handleAlphaWithCardTopConstraint(value: self.cardViewTopConstraint?.constant ?? self.view.frame.height)
        case .ended:
            if velocity.y > 1500.0 {
                hide()
                return
            }
            if let safeAreaHeight = UIApplication.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
               let bottomPadding = UIApplication.keyWindow?.safeAreaInsets.bottom {
                if self.cardViewTopConstraint?.constant ?? safeAreaHeight < (safeAreaHeight + bottomPadding) * 0.25 {
                    showCard(nil, atState: .expanded)
                } else if self.cardViewTopConstraint?.constant ?? safeAreaHeight < (safeAreaHeight) - 70 {
                    showCard(nil, atState: .normal)
                } else {
                    hide()
                }
            }
        default: break
        }
    }
// #MARK: ******* Private propertyes *******
    private var window: UIWindow?
    private var parentWindow: UIWindow?
    private var contentView: UIView? {
        didSet {
            self.cardView?.subviews.forEach({ $0.removeFromSuperview() })
            if let _view = self.contentView {
                self.cardView?.addSubview(_view)
                _view.fillSuperview()
            }
        }
    }
    private var cardPanStartingTopConstraint: CGFloat = 0
    private var cardPanStartingTopConstant : CGFloat = 30.0
    
    private lazy var bgView: UIView? = {
        let _view = UIView()
        _view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        _view.isUserInteractionEnabled = true
        return _view
    }()
    private lazy var cardView: UIView? = {
        let _view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 120))
        _view.backgroundColor = UIX3CustomControl.Defaults.Color.background
        return _view
    }()
    private lazy var handleView: UIView? = {
        let _view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 120))
        _view.backgroundColor = UIX3CustomControl.Defaults.Color.background
        return _view
    }()
    private var cardViewTopConstraint: NSLayoutConstraint?

// #MARK: ******* Public propertyes *******
    
// #MARK: ******* Public methods *******
    private func showCard(_ contant: UIView?, atState: CardViewState = .normal, atHeigth: CGFloat = 0.0) {
        self.view.layoutIfNeeded()
        self._viewState = atState
        if let safeAreaHeight = UIApplication.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.keyWindow?.safeAreaInsets.bottom {
            if atState == .expanded {
                cardViewTopConstraint?.constant = 30.0
            } else if atState == .compact {
                cardViewTopConstraint?.constant = self.view.bounds.height - bottomPadding - atHeigth
                handleView?.removeFromSuperview()
            } else {
                cardViewTopConstraint?.constant = (safeAreaHeight + bottomPadding) / 2.0
            }
            cardPanStartingTopConstraint = cardViewTopConstraint?.constant ?? safeAreaHeight
        }
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        showCard.addAnimations {
            self.bgView?.alpha = 0.7
        }
        showCard.startAnimation()
    }
    private func hideCard(_ completion: @escaping () -> Void) {
        self.view.layoutIfNeeded()
        if let safeAreaHeight = UIApplication.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        }
        let hideCard = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        hideCard.addAnimations {
            self.bgView?.alpha = 0.0
        }
        hideCard.addCompletion({ position in
            if position == .end {
                if(self.presentingViewController != nil) {
                    self.dismiss(animated: false, completion: nil)
                }
                completion()
            }
        })
        hideCard.startAnimation()
    }

    open func show(_ contant: UIView?, atState: CardViewState = .normal, atHeigth: CGFloat = 0.0) {
        if isNotReady || self.window == nil { return }
        self.window?.makeKeyAndVisible()
        self.contentView = contant
        self.showCard(contant, atState: atState, atHeigth: atHeigth)
    }
    
    open func hide() {
        self.hideCard( {
            self.parentWindow?.makeKeyAndVisible()
            self.window = nil
            self.parentWindow = nil
            self.contentView?.removeFromSuperview()
            self.contentView = nil
        })
    }
}
