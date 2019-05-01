import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var btn: TKTransitionSubmitButton!

    @IBOutlet var btnFromNib: TKTransitionSubmitButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)

        let bg = UIImageView(image: UIImage(named: "Login"))
        bg.frame = view.frame
        view.addSubview(bg)

        btn = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width - 64, height: 44))
        btn.center = view.center
        btn.frame.bottom = view.frame.height - 60
        btn.setTitle("Sign in", for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        btn.addTarget(self, action: #selector(ViewController.onTapButton(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)

        view.bringSubview(toFront: btnFromNib)
    }

    @IBAction func onTapButton(_ button: TKTransitionSubmitButton) {
        button.animate(1, completion: { () -> Void in
            let secondVC = SecondViewController()
            secondVC.transitioningDelegate = self
            self.present(secondVC, animated: true, completion: nil)
        })
    }

    // MARK: UIViewControllerTransitioningDelegate

    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
