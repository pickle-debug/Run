//
//  RecordTableVC.swift
//  Run
//
//  Created by mac on 2021/10/13.
//

import UIKit

class RecordDetailsVC: UITableViewController {
    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var GenchLabel: UILabel!
    @IBOutlet weak var GenchImageView: UIImageView!
        
    var status: BadgeStatus!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let badgeRotaion = CGAffineTransform(rotationAngle: .pi / 8)
        
        badgeImageView.image = UIImage(named: status.badge.imageName)
        nameLabel.text = status.badge.name
        distanceLabel.text = FormatDisplay.distance(status.badge.distance)
        let earnedDate = FormatDisplay.date(status.earned?.timestamp)
        earnedLabel.text = "Reached on \(earnedDate)"
        
        let bestDistance = Measurement(value: status.best!.distance, unit: UnitLength.meters)
        let bestSpeed = FormatDisplay.speed(distance: bestDistance,
                                          seconds: Int(status.best!.duration),
                                          outputUnit: UnitSpeed.minutesPerKilometer)
        let bestDate = FormatDisplay.date(status.earned?.timestamp)
        bestLabel.text = "Best: \(bestSpeed),\(bestDate)"
        
        let earnedDistance = Measurement(value: status.earned!.distance, unit: UnitLength.meters)
        let earnedDuration = Int(status.earned!.duration)
        
        if let Gench = status.Gench {
            GenchImageView.transform = badgeRotaion
            GenchImageView.alpha = 1
            let GenchDate = FormatDisplay.date(Gench.timestamp)
            GenchLabel.text = "Earned on \(GenchDate)"
        } else {
            GenchImageView.alpha = 0
            let GenchDistance = earnedDistance * BadgeStatus.GenchMultiplier
            let speed = FormatDisplay.speed(distance: GenchDistance,
                                            seconds: earnedDuration,
                                            outputUnit: UnitSpeed.minutesPerKilometer)
            GenchLabel.text = "Speed< \(speed) for Gench!"
        }
    }
    @IBAction func infoButtonTapped() {
        let alert = UIAlertController (title: status.badge.name,
                                       message: status.badge.information,
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
