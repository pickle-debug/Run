//
//  EndViewController.swift
//  RunDemo
//
//  Created by 何纪栋 on 2021/7/12.
//

import UIKit
import BubbleTransition

class StopRunVC: UIViewController {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    weak var interactiveTransition: BubbleInteractiveTransition?
    
    
    
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
    
    @IBAction func closeAction(_ sender: AnyObject) {
      self.dismiss(animated: true, completion: nil)
      interactiveTransition?.finish()
    }
    
}
