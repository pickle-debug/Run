//
//  RecordCell.swift
//  Run
//
//  Created by mac on 2021/10/13.
//

import UIKit

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var GenchImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    
    var status: BadgeStatus! {
        didSet {
            configure()
        }
    }
    
    private let redLabel = #colorLiteral(red: 1, green: 0.07843137255, blue: 0.1725490196, alpha: 1)
    private let greenLabel = #colorLiteral(red: 0.06987128407, green: 0.8397964239, blue: 0.2087419033, alpha: 1)
    private let badgeRotation = CGAffineTransform(rotationAngle: .pi / 8)
    
    private func configure() {
        GenchImageView.isHidden = status.Gench == nil
        if let earned = status.earned {
            nameLabel.text = status.badge.name
            nameLabel.textColor = greenLabel
            let dateEarned = FormatDisplay.date(earned.timestamp)
            earnedLabel.text = "Earned: \(dateEarned)"
            earnedLabel.textColor=greenLabel
            badgeImageView.image = UIImage(named: status.badge.imageName)
            GenchImageView.transform = badgeRotation
            isUserInteractionEnabled = true
            accessoryType = .disclosureIndicator
        } else {
            nameLabel.text = "?????"
            nameLabel.textColor = redLabel
            let formattedDistance = FormatDisplay.distance(status.badge.distance)
            earnedLabel.text = "Run \(formattedDistance) to earn"
            earnedLabel.textColor = redLabel
            badgeImageView.image = nil
            isUserInteractionEnabled = false
            accessoryType = .none
            selectionStyle = .none
        }
    }
}
