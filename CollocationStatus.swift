//
//  Badge.swift
//  Run
//
//  Created by mac on 2021/10/13.
//

import Foundation

struct BadgeStatus {
    let badge: Badge
    let earned: Run?
    let Gench: Run?
    let best: Run?
    
    static let GenchMultiplier = 1.1
    
    static func badgeEarned(runs: [Run]) -> [BadgeStatus] {
        return Badge.allBadges.map {badge in
            var earned: Run?
            var Gench: Run?
            var best: Run?
            
            for run in runs where run.distance > badge.distance {
                if earned == nil {
                    earned = run
                }
                let earnedSpeed = earned!.distance / Double(earned!.duration)
                let runSpeed = run.distance / Double(run.duration)
                
                if Gench == nil && runSpeed > earnedSpeed * GenchMultiplier {
                    Gench = run
                }
                if let existingBest = best {
                    let bestSpeed = existingBest.distance / Double(existingBest.duration)
                    if runSpeed > bestSpeed {
                        best = run
                        }
                    } else {
                        best = run
                    }
                }
                
                return BadgeStatus(badge: badge, earned: earned, Gench: Gench , best: best)
        }
    }
}
