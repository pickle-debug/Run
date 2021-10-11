//
//  FirstViewController.swift
//  RunDemo
//
//  Created by 何纪栋 on 2021/7/12.
//

import UIKit
import BubbleTransition


class FirstViewController: UIViewController, UIViewControllerTransitioningDelegate {
//TO DO 优化代码，复用
    
 
    @IBOutlet weak var Start: UIButton!
 
    let transition = BubbleTransition()

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let controller = segue.destination
      controller.transitioningDelegate = self
      controller.modalPresentationCapturesStatusBarAppearance = true
      controller.modalPresentationStyle = .custom
    }

    // MARK: UIViewControllerTransitioningDelegate

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .present
      transition.startingPoint = Start.center
      transition.bubbleColor = Start.backgroundColor!
      return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .dismiss
      transition.startingPoint = Start.center
      transition.bubbleColor = Start.backgroundColor!
      return transition
    }

    
    override func viewDidLoad() {
           super.viewDidLoad()
        let RunButton = UIButton(type: .custom)
        RunButton.frame = CGRect(x: 160,y: 100, width: 50, height: 50)
        RunButton.layer.cornerRadius = 0.5 * RunButton.bounds.size.width
        view.addSubview(RunButton)
       }

//    func initBtn() {
////        let screenSize = UIScreen.main.bounds.size
////        RunButton.frame = CGRect(x: screenSize.width / 2, y: screenSize.height / 2,width: 200, height: 200)
//        RunButton.layer.cornerRadius = 5
    
//        let icon = UIImage(named: "icon")
//        RunButton.setImage(UIImage(named:"icon.png"), for: .normal)
    }
    
//    @IBAction func startRun(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "StartRun", sender: sender)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "StartRun"{
//            let RunViewController = segue.destination as! RunViewController
//            RunViewController.modalPresentationStyle = .fullScreen
//        }
//    }
//}





    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

