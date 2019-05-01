import Foundation
import UIKit

@IBDesignable
open class TKTransitionSubmitButton: UIButton, UIViewControllerTransitioningDelegate, CAAnimationDelegate {
    lazy var spiner: SpinerLayer! = {
        let s = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(s)
        return s
    }()

    @IBInspectable open var spinnerColor: UIColor = UIColor.white {
        didSet {
            spiner.spinnerColor = spinnerColor
        }
    }

    open var didEndFinishAnimation: (() -> Void)?

    let springGoEase = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    let shrinkCurve = CAMediaTimingFunction(name: .linear)
    let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    let shrinkDuration: CFTimeInterval = 0.1
    @IBInspectable open var normalCornerRadius: NSNumber = 0.0 {
        didSet {
            layer.cornerRadius = CGFloat(normalCornerRadius.doubleValue)
        }
    }

    var cachedTitle: String?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    func setup() {
        clipsToBounds = true
        spiner.spinnerColor = spinnerColor
    }

    open func startLoadingAnimation() {
        cachedTitle = title(for: .normal)
        setTitle("", for: .normal)
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.layer.cornerRadius = self.frame.height / 2
        }, completion: { (_) -> Void in
            self.shrink()
            Timer.schedule(delay: self.shrinkDuration - 0.25) { _ in
                self.spiner.animation()
            }
        })
    }

    open func startFinishAnimation(_ delay: TimeInterval, _ animation: CAMediaTimingFunction? = nil, completion: (() -> Void)?) {
        Timer.schedule(delay: delay) { _ in
            self.didEndFinishAnimation = completion
            self.expand(animation)
            self.spiner.stopAnimation()
        }
    }

    open func animate(_ duration: TimeInterval, _ animation: CAMediaTimingFunction? = nil, completion: (() -> Void)?) {
        startLoadingAnimation()
        startFinishAnimation(duration, animation, completion: completion)
    }

    open func setOriginalState() {
        returnToOriginalState()
        spiner.stopAnimation()
    }

    public func animationDidStop(_ anim: CAAnimation, finished _: Bool) {
        let a = anim as! CABasicAnimation
        if a.keyPath == "transform.scale" {
            didEndFinishAnimation?()
            Timer.schedule(delay: 1) { _ in
                self.returnToOriginalState()
            }
        }
    }

    open func returnToOriginalState() {
        layer.removeAllAnimations()
        setTitle(cachedTitle, for: .normal)
        spiner.stopAnimation()
        layer.cornerRadius = CGFloat(normalCornerRadius.doubleValue)
    }

    func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }

    func expand(_ animation: CAMediaTimingFunction? = nil) {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 26.0
        expandAnim.timingFunction = animation ?? expandCurve
        expandAnim.duration = 0.3
        expandAnim.delegate = self
        expandAnim.fillMode = .forwards
        expandAnim.isRemovedOnCompletion = false
        layer.add(expandAnim, forKey: expandAnim.keyPath)
    }
}
