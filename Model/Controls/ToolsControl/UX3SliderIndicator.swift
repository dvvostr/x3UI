

import Foundation
import UIKit

@IBDesignable
open class UX3SliderIndicatorControl: UIControl {
    fileprivate var _buttons = [UIButton]()
    fileprivate var _selectedButton: UIButton?
    fileprivate var _selectedSegmentIndex = 0
    fileprivate var _thumbView: UIView = {
        return UIView()
    }()
    public var delegate: ControlEventDelegate?

    @IBInspectable private var codes: [String] = [] {
        didSet { self.updateView() }
    }

    @IBInspectable public var animationDuration: CGFloat = 0.3
    @IBInspectable public var thumbViewAlpha: CGFloat = 1.0 {
        didSet {
            self._thumbView.alpha = thumbViewAlpha
        }
    }
    @IBInspectable public var segmentColor: UIColor = .clear {
        didSet { self.updateView() }
    }
    @IBInspectable public var thumbColor: UIColor = .darkGray {
        didSet { self.updateView() }
    }
    @IBInspectable public var segmentSelectedColor: UIColor = .darkGray {
        didSet { self.updateView() }
    }
    public var selectedSegmentIndex: Int {
        get { return self._selectedSegmentIndex }
        set {
            if self._buttons.indices.contains(newValue) {
                self.handleButtonClick(sender: self._buttons[newValue], animated: false)}
            }
    }
    /*
    -1 : Circuled corner of element
     0 : Nor rounded corner of element
     >0 : Round value of element
     */
    fileprivate var _controlRoundValue: CGFloat = 0
    public var controlRoundValue: CGFloat {
        get { return _controlRoundValue }
        set {
            self._controlRoundValue = (newValue == -1) ? (frame.height / 2) : (newValue > (frame.height / 2)) ? (frame.height / 2) : newValue
            self.updateView()
        }
    }
    public var thumbViewHidden: Bool = false {
        didSet {
            self._thumbView.isHidden = thumbViewHidden
        }
    }
    public var buttonSpacing: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
//*******************************//
    public func setSegmentedWith<T>(items: T) {
        if items is [String] {
            self.codes = items as! [String]
        } else if items is Int {
            self.codes = [String](repeating: "", count: items as! Int)
        }
    }
//*******************************//
    private func resetViews() {
        self._buttons.removeAll()
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    private func updateView() {
        resetViews()
        self.clipsToBounds = false
        self.addSubview(_thumbView)
        self.setButtonsWithText()
        self.layoutButtonsOnStackView()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = _controlRoundValue
        super.backgroundColor = self.backgroundColor
        self.layer.borderColor = self.segmentColor.cgColor
        setThumbView()
        for (_index, _btn) in self._buttons.enumerated() {
            _btn.frame = setFrameForButtonAt(index: _index)
        }
    }
    private func setThumbView() {
        let _width = ((bounds.width + (CGFloat(_buttons.count) > 0 ? self.buttonSpacing : 0)) / (CGFloat(_buttons.count == 0 ? 1 : CGFloat(_buttons.count)))) - self.buttonSpacing
        let _posX = thumbPositionX
        let _posY = (bounds.height - bounds.height) / 2
        self._thumbView.frame = CGRect(x: _posX, y: _posY, width: _width, height: bounds.height)
        self._thumbView.layer.cornerRadius = _controlRoundValue
        self._thumbView.backgroundColor = thumbColor
    }
    private func layoutButtonsOnStackView() {
        let _view = UIStackView(arrangedSubviews: _buttons)
        _view.axis = .horizontal
        _view.alignment = .fill
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.distribution = .fillEqually
        self.addSubview(_view)
        _view.spacing = self.buttonSpacing
        NSLayoutConstraint.activate([
            _view.topAnchor.constraint(equalTo: topAnchor),
            _view.bottomAnchor.constraint(equalTo: bottomAnchor),
            _view.trailingAnchor.constraint(equalTo: trailingAnchor),
            _view.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])
        self.bringSubviewToFront(self._thumbView)
    }
    private func setFrameForButtonAt(index: Int) -> CGRect {
        var _frame = CGRect.zero
        let _height = self.bounds.height
        let _width = _height
        let _thumbPosY = (bounds.height - _height) / 2
        let _firstPosX = 0.0
        let _lastPosX = self.bounds.width - self._thumbView.frame.width
        let _thumbTotalWidth = self._buttons.count == 0 ? 0 : self.bounds.width / CGFloat(self._buttons.count)
        let _startPos = (_thumbTotalWidth *  CGFloat(index)) + ((_thumbTotalWidth - _thumbView.bounds.width) / 2)
        if index == 0 {
            _frame = CGRect(x: _firstPosX, y: _thumbPosY, width: _width, height: _height)
        } else if index == self._buttons.count - 1 {
            _frame = CGRect(x: _lastPosX, y: _thumbPosY, width: _width, height: _height)
        } else {
            _frame = CGRect(x: _startPos, y: _thumbPosY, width: _width, height: _height)
        }
        return _frame
    }
//****************************//
    private func setButtonsWithText() {
        guard self.codes.count != 0 else { return }
        for _ in codes {
            let _button = UIButton(type: .system)
            _button.backgroundColor = self.segmentColor
            _button.layer.cornerRadius = self._controlRoundValue
            _button.setTitle("", for: .normal)
            _button.addTarget(self, action: #selector(handleButtonClick(sender:)), for: .touchUpInside)
            self._buttons.append(_button)
        }
        self._buttons[_selectedSegmentIndex].setTitleColor(UIColor.clear, for: .normal)
    }
}
extension UX3SliderIndicatorControl {
    fileprivate func performAction() {
        sendActions(for: .valueChanged)
        self.delegate?.controlEvent?(self, event: ControlEvent.int(self.selectedSegmentIndex))
    }
    fileprivate var thumbPositionX: CGFloat {
        get {
            return (self._selectedButton?.convert(CGPoint(x: 0, y: 0), to: self).x) ?? 0
        }
    }
    public func setSelectedSegmentIndex(index: Int, animated: Bool) {
        if self._buttons.indices.contains(index) {
            let _btn = _buttons[index]
            self.handleButtonClick(sender: _btn, animated: true)
        }
    }
    @objc fileprivate func handleButtonClick(sender: UIButton) {
        self.handleButtonClick(sender: sender, animated: true)
    }
    @objc fileprivate func handleButtonClick(sender: UIButton, animated: Bool) {
        for (_index, _btn) in self._buttons.enumerated() {
            _btn.setTitleColor(UIColor.clear, for: .normal)
            if _btn == sender {
                self._selectedButton = sender
                self._selectedSegmentIndex = _index
                self.moveThumbView(at: _index, position: thumbPositionX, animated: animated)
                _btn.tintColor = segmentSelectedColor
            }
        }
        self.performAction()
    }
    fileprivate func moveThumbView(at index: Int, position x: CGFloat?, animated: Bool) {
        let _posX = x ?? (index == 0 ? 0 : bounds.width / CGFloat(_buttons.count) *  CGFloat(index))
        UIView.animate(withDuration: animated ? TimeInterval(self.animationDuration) : 0, animations: {
            self._thumbView.frame.origin.x = _posX
        })
    }
}
