//
//  FirstViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VegVanStopLocation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    __weak IBOutlet MKMapView *_mapView;
    IBOutlet UIWebView *mapView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

//@property (nonatomic, strong) IBOutlet UIWebView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
-(void)plotVegVanStopLocations;
- (void)startStandardUpdates;
-(void)promptForLocationServices;

@end
