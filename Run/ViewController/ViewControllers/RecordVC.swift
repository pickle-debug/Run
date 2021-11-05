//
//  RecordVC.swift
//  Run
//
//  Created by mac on 2021/11/2.
//

import UIKit
import AnimatedCollectionViewLayout


class RecordVC: UIViewController {

    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionView.ScrollDirection = .horizontal
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
