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
    

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    weak var interactiveTransition: BubbleInteractiveTransition?

    private var run: Run!
    var locationManager = CLLocationManager()
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismiss(animated: true, completion: nil)
        startRun()
        buttonStackView.isHidden = true
        
    }
    @IBAction func pause() {
            stopRun()
        timer?.invalidate()
            pauseButton.isHidden = true
        buttonStackView.isHidden = false
    }
        
    @IBAction func contine(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        pauseButton.isHidden = false
        buttonStackView.isHidden = true
    }
    @IBAction func end(){
        self.saveRun()
//        self.performSegue(withIdentifier: .details, sender: nil)
        self.dismiss(animated: true, completion: nil)
        interactiveTransition?.finish()
//                    let alertController = UIAlertController(title: "跑完了？",
//                                                            message: "你想结束跑步吗？",
//                                                            preferredStyle: .actionSheet)
//                    alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
//                    alertController.addAction(UIAlertAction(title: "保存", style: .default) { _ in
//                        self.saveRun()
//                        self.performSegue(withIdentifier: .details, sender: nil)
//                    })
//                    alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
//                        self.stopRun()
//                        _ = self.navigationController?.popToRootViewController(animated: true)
//                    })
//
//                    present(alertController, animated: true)
            }
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
      UIApplication.shared.setStatusBarStyle(.default, animated: true)
        
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
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

//extension RunPageVC: SegueHandlerType {
//    enum SegueIdentifier: String {
//        case details = "StopRunVC"
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segueIdentifier(for: segue) {
//        case .details:
//            let destination = segue.destination as! StopRunVC
//            destination.run = run
//        }
//        if segue.identifier == "StopRunVC"{
//            let StopRunVC = segue.destination as! StopRunVC
//            StopRunVC.modalPresentationStyle = .fullScreen
//        }
//    }
//}

extension RunPageVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else{ continue }

            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                _ = [lastLocation.coordinate, newLocation.coordinate]
            }

            locationList.append(newLocation)
        }
    }
}
