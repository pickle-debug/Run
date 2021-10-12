//
//  EndViewController.swift
//  RunDemo
//
//  Created by 何纪栋 on 2021/7/12.
//

import UIKit
import BubbleTransition

class StopRunVC: UIViewController, UIViewControllerTransitioningDelegate{
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    let transition = BubbleTransition()
    
    var run: Run!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        let seconds = Int(run.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(run.timestamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedspeed = FormatDisplay.speed(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerKilometer)
        
        distanceLabel.text = "\(formattedDistance)"
        dateLabel.text = formattedDate
        timeLabel.text = "\(formattedTime)"
        speedLabel.text = "\(formattedspeed)"
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let controller = segue.destination
      controller.transitioningDelegate = self
      controller.modalPresentationCapturesStatusBarAppearance = true
      controller.modalPresentationStyle = .custom
    }

    // MARK: UIViewControllerTransitioningDelegate

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .present
      transition.startingPoint = closeButton.center
      transition.bubbleColor = closeButton.backgroundColor!
      return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .dismiss
      transition.startingPoint = closeButton.center
      transition.bubbleColor = closeButton.backgroundColor!
      return transition
    }

    }
