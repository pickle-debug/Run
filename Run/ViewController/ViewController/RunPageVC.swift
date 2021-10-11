//
//  RunPageVC.swift
//  Run
//
//  Created by mac on 2021/10/11.
//

import UIKit
import CoreLocation
import BubbleTransition

class RunPageVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var controlButton: UIButton!
    weak var interactiveTransition: BubbleInteractiveTransition?

    private var run: Run!
    var locationManager = CLLocationManager()
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        controlButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
            self.dismiss(animated: true, completion: nil)
            interactiveTransition?.finish()
    }
    
//    @IBAction func flipButton() {
//        if(centerButton.titleLabel?.text == "开始跑步") {
//            startRun()
//            centerButton.setTitle("暂停", for: .normal)
//        } else {
//            stopRun()
//            centerButton.setTitle("开始跑步", for: .normal)
//            let alertController = UIAlertController(title: "跑完了？",
//                                                    message: "你想结束跑步吗？",
//                                                    preferredStyle: .actionSheet)
//            alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
//            alertController.addAction(UIAlertAction(title: "保存", style: .default) { _ in
//                self.stopRun()
//                self.saveRun()
//                self.performSegue(withIdentifier: .details, sender: nil)
//            })
//            alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
//                self.stopRun()
//                _ = self.navigationController?.popToRootViewController(animated: true)
//            })
//
//            present(alertController, animated: true)
//        }
//    }
    
    private func startRun(){
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }

    private func stopRun() {
        locationManager.stopUpdatingLocation()
    }

    func eachSecond() {
        seconds += 1
        updateDisplay()
    }

    func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedSpeed = FormatDisplay.speed(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerKilometer)

        distanceLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
        speedLabel.text = "\(formattedSpeed)"
    }

    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
    }
    private func saveRun() {
        let newRun = Run (context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.timestamp = Date()

        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }

        CoreDataStack.saveContext()

        run = newRun
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
        
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
      UIApplication.shared.setStatusBarStyle(.default, animated: true)
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

extension RunPageVC: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "EndViewController"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! EndViewController
            destination.run = run
        }
    }
}

extension RunPageVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else{ continue }

            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
            }

            locationList.append(newLocation)
        }
    }
}
