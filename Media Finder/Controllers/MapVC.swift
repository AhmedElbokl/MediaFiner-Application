//
//  MapVC.swift
//  Media Finder
//
//  Created by ReMoSTos on 07/05/2023.
//

import MapKit

//delegation 1.
protocol MessageSending: AnyObject /*class*/ {
    func sendMSG(_ message: String)
}

class MapVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    private var locationManager = CLLocationManager()
    
    //delegation 2.
    weak var delegate: MessageSending?
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        mapView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Actions
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        //delegation 3.
        delegate?.sendMSG(addressLabel.text ?? "")
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Extention
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        let location: CLLocation = CLLocation.init(latitude: lat, longitude: long)
        getAddress(location)
    }
}

//MARK: private mathods extension
extension MapVC {
    private func getAddress(_ location: CLLocation) {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let firstPlaceMark = placeMarks?.first {
                self.addressLabel.text = firstPlaceMark.compactAddress ?? "N/A"
            }
        }
    }
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorisation()
        } else {
            print("please enable location services (GPS)")
        }
    }
    private func checkLocationAuthorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            getCurrentLocation()
        case .denied, .restricted:
            print("can't get location")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            print("can't get location")
        }
    }
   /* private func goTestLocation() {
        let location: CLLocation = CLLocation(latitude: 30.096655, longitude: 31.662533)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        getAddress(location)
    }*/
   private func getCurrentLocation() {
       if let location = locationManager.location?.coordinate {
           let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
           mapView.setRegion(region, animated: true)
           getAddress(locationManager.location!)
       }
    }

}
