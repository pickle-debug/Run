//import UIKit
//import CoreLocation
//import BubbleTransition
//
//
//class RunViewController: UIViewController {
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var speedLabel: UILabel!
//    @IBOutlet weak var distenceLabel: UILabel!
//
//
//    @IBOutlet weak var closeButton: UIButton!
//    weak var interactiveTransition: BubbleInteractiveTransition?
//
//    private var run: Run!
//    var locationManager = CLLocationManager()
//    private var seconds = 0
//    private var timer: Timer?
//    private var distance = Measurement(value: 0, unit: UnitLength.meters)//what is Measurement?need mark
//    private var locationList: [CLLocation] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        timer?.invalidate()
//        locationManager.stopUpdatingLocation()
//
//        super.viewWillDisappear(animated)
//        UIApplication.shared.setStatusBarStyle(.default, animated: true)
//    }
//
//    @IBAction func closeAction(_ sender: AnyObject) {
//      self.dismiss(animated: true, completion: nil)
//
//      // NOTE: when using interactive gestures, if you want to dismiss with a button instead, you need to call finish on the interactive transition to avoid having the animation stuck
//      interactiveTransition?.finish()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//      super.viewWillAppear(animated)
//      UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
//    }
//
//
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
//
//    @IBAction func startTapped() {
//        startRun()
//    }
//
//    @IBAction func stopTapped() {
////            TO DO alert
////        let alertController = UIAlertController(title: "跑完了？",
////                                                message: "你想结束跑步吗？",
////                                                preferredStyle: .actionSheet)
////        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
////        alertController.addAction(UIAlertAction(title: "保存", style: .default) { _ in
////            self.stopRun()
////            self.saveRun()
////            self.performSegue(withIdentifier: .details, sender: nil)
////        })
////        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
////            self.stopRun()
////            _ = self.navigationController?.popToRootViewController(animated: true)
////        })
////
////        present(alertController, animated: true)
//    }
//    //TO DO func for flip button.title
//    private func startRun(){
//        seconds = 0
//        distance = Measurement(value: 0, unit: UnitLength.meters)
//        locationList.removeAll()
//        updateDisplay()
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            self.eachSecond()
//        }
//        startLocationUpdates()
//    }
//
//    private func stopRun() {
//        locationManager.stopUpdatingLocation()
//    }
//
//    func eachSecond() {
//        seconds += 1
//        updateDisplay()
//    }
//
//    func updateDisplay() {
//        let formattedDistance = FormatDisplay.distance(distance)
//        let formattedTime = FormatDisplay.time(seconds)
//        let formattedSpeed = FormatDisplay.speed(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerKilometer)
//
//        distanceLabel.text = "\(formattedDistance)"
//        timeLabel.text = "\(formattedTime)"
//        speedLabel.text = "\(formattedSpeed)"
//    }
//
//    private func startLocationUpdates() {
//        locationManager.delegate = self
//        locationManager.activityType = .fitness
//        locationManager.distanceFilter = 10
//        locationManager.startUpdatingLocation()
//        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.requestAlwaysAuthorization()
//    }
//    private func saveRun() {
//        let newRun = Run (context: CoreDataStack.context)
//        newRun.distance = distance.value
//        newRun.duration = Int16(seconds)
//        newRun.timestamp = Date()
//
//        for location in locationList {
//            let locationObject = Location(context: CoreDataStack.context)
//            locationObject.timestamp = location.timestamp
//            locationObject.latitude = location.coordinate.latitude
//            locationObject.longitude = location.coordinate.longitude
//            newRun.addToLocations(locationObject)
//        }
//
//        CoreDataStack.saveContext()
//
//        run = newRun
//    }
//}
//
//extension RunViewController: SegueHandlerType {
//    enum SegueIdentifier: String {
//        case details = "EndViewController"
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segueIdentifier(for: segue) {
//        case .details:
//            let destination = segue.destination as! EndViewController
//            destination.run = run
//        }
//    }
//}
//
//extension RunViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        for newLocation in locations {
//            let howRecent = newLocation.timestamp.timeIntervalSinceNow
//            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else{ continue }
//
//            if let lastLocation = locationList.last {
//                let delta = newLocation.distance(from: lastLocation)
//                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
//                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
//            }
//
//            locationList.append(newLocation)
//        }
//    }
//}
