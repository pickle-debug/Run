//
//  RootVC.swift
//  Run
//
//  Created by mac on 2021/11/5.
//

import UIKit


let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height

class RootVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var sv_home: UIScrollView!
 
    var HomePageVC:UIViewController!
    var RecordVC:UIViewController!
    var viewAyy:[UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        HomePageVC = storyboard!.instantiateViewController(withIdentifier: kHomeVCID)
        RecordVC = storyboard!.instantiateViewController(withIdentifier: kRecordVCID)
        
        
        sv_home.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        for i in 0...viewAyy.count{
            viewAyy[i].frame = CGRect(x: CGFloat(i) * screenW, y: 0, width: screenW, height: sv_home.frame.height)
            sv_home.addSubview(viewAyy[i])
        }
        sv_home.contentSize = CGSize(width: screenW * CGFloat(viewAyy.count), height: 0)
        sv_home.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
           if scrollView == sv_home {
               let _currPage = (scrollView.contentOffset.x + scrollView.frame.width * 0.6) / scrollView.frame.width
           }
       }
       

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
