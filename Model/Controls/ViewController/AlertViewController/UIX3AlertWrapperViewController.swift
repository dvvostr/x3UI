import UIKit
import x3Core


@IBDesignable open class UIX3AlertWrapperViewController: UIX3CustomAlertViewController {
// MARK: ******* Defaults *******
// See *UX3CustomControl.Defaults*
    
    public struct Defaults {
        public struct AlertView {
        }
    }
// MARK: ************ Initialize & invalidate ************
    open override func setupView() {
        super.setupView()
    }
    open override func invalidate() {
        super.invalidate()
        let _paddingX: CGFloat = UIX3AlertViewController.Defaults.AlertView.paddingX,
            _paddingY: CGFloat = UIX3AlertViewController.Defaults.AlertView.paddingY,
            _height: CGFloat = self.alertView?.bounds.height ?? _paddingY,
            _width: CGFloat = self.alertView?.bounds.width ?? _paddingX
        var _buttonHeight: CGFloat = 0
        

        self.buttonView?.removeFromSuperview()
        if let _view = self.buttonView, self.buttonOptions.count > 0 {
            self.alertView?.addSubview(_view)
            _buttonHeight = _view.arrangedSubviews.count == 0 ? 0 : (UIX3CustomAlertViewController.Defaults.AlertView.Buttons.height * CGFloat(_view.arrangedSubviews.count)) + (_paddingY * CGFloat(_view.arrangedSubviews.count  - 1))
            _view.frame = CGRect(
                x: _paddingX,
                y: _height - _view.bounds.height - _paddingY,
                width: _width - (_paddingX * 2),
                height: _buttonHeight
            )
            _view.subviews.first?.getContraints(attribute: .trailing, relation: nil).forEach({ $0.constant = 0 })
        }
        self.wripper?.removeFromSuperview()
        if let _view = self.wripper {
            self.alertView?.addSubview(_view)
            self.wripper?.frame = CGRect(
                x: _paddingX,
                y: _paddingY,
                width: _width - (_paddingX * 2),
                height: _height - _buttonHeight - (_paddingY * 3)
            )
        }
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.invalidate()
    }
    open override func invalidateButtonView() {
        super.invalidateButtonView()
        self.buttonView?.removeAllArrangedSubviews()
        for _item in self.buttonOptions.elements() {
            let _buttonType = UIX3CustomAlertButtonOptions.getAlertButtonType(_item),
            _button = createButton(_buttonType, settings: self.getButtonSettings(_buttonType))
            if _buttonType == .ok || _buttonType == .cancel {
                self.buttonView?.addArrangedSubview(_button)
            }
        }
    }
    open func invalidateButtonView(_ useContainer: Bool = false) {
        super.invalidateButtonView()
        self.buttonView?.removeAllArrangedSubviews()
        for _item in self.buttonOptions.elements() {
            let _view = UIView(),
                _buttonType = UIX3CustomAlertButtonOptions.getAlertButtonType(_item),
            _button = createButton(_buttonType, settings: self.getButtonSettings(_buttonType))
            _view.addSubview(_button)
            _button.widthAnchor.constraint(equalToConstant: _button.bounds.width).isActive = true
            _button.anchorCenterSuperview()
            if _buttonType == .ok || _buttonType == .cancel {
                self.buttonView?.addArrangedSubview(_view)
            }
        }
    }
    deinit {
    }
// #MARK: ******* Handles *******
    private func createWrapper(){
    }
    open override func buttonViewClick(_ sender: UX3CustomButton, buttonType: UIX3CustomAlertButtonType) {
        super.buttonViewClick(sender, buttonType: buttonType)
    }
// #MARK: ******* Private propertyes *******
    private lazy var buttonView: UIStackView? = {
        let _view = UIStackView()
        _view.axis = .vertical
        _view.alignment = .fill
        _view.distribution = .fillProportionally
        _view.spacing = UIX3CustomAlertViewController.Defaults.AlertView.Buttons.spacing
        return _view
    }()
    private lazy var wripper: UIView? = {
        let _view = UIView()
        _view.backgroundColor = UIColor.clear
        return _view
    }()
// #MARK: ******* Public propertyes *******
    open var contentView: UIView? {
        didSet {
            self.wripper?.subviews.forEach({ $0.removeFromSuperview() })
            if let _view = self.contentView {
                self.wripper?.addSubview(_view)
                _view.fillSuperview()
            }
            self.invalidate()
        }
    }
}
