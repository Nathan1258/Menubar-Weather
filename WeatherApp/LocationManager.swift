//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 01/01/2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject{
    
    @Published var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last, currentLocation == nil else {return}
        
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print( "location manager failed with error \(error)" )
    }
    func getPlace(for location: CLLocation,
                      completion: @escaping (CLPlacemark?) -> Void) {
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                
                guard error == nil else {
                    print("*** Error in \(#function): \(error!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let placemark = placemarks?[0] else {
                    print("*** Error in \(#function): placemark is nil")
                    completion(nil)
                    return
                }
                completion(placemark)
            }
        }
    
    func getLocation(for address: String) async throws -> CLLocation? {
        let placemarks = try await CLGeocoder().geocodeAddressString(address)
        return placemarks.first?.location
    }

}
