//
//  MapViewController.swift
//  Yelp
//
//  Created by Piyush Sharma on 7/25/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.scrollEnabled = true
        mapView.zoomEnabled = true
        
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)
        addAnnotationAtCoordinate()
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func addAnnotationAtCoordinate() {
        for business in self.businesses {
            let annotation = MKPointAnnotation()
            let location = CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)
            annotation.coordinate = location
            annotation.title = business.name
            annotation.subtitle = business.address
                    
            mapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
