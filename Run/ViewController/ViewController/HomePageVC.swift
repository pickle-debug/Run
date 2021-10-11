//
//  HomePageVC.swift
//  Run
//
//  Created by 何纪栋 on 2021/9/25.
//

import UIKit
import BubbleTransition

class HomePageVC: UIViewController,UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var RunButton: UIButton!
    
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let controller = segue.destination as? RunPageVC{
            controller.transitioningDelegate = self
            controller.modalPresentationCapturesStatusBarAppearance = true
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        }
    }
    // MARK: UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .present
      transition.startingPoint = RunButton.center
      transition.bubbleColor = RunButton.backgroundColor!
      return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .dismiss
      transition.startingPoint = RunButton.center
      transition.bubbleColor = RunButton.backgroundColor!
      return transition
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
      return interactiveTransition
    }
}
