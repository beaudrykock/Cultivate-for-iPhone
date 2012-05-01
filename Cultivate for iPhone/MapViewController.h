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
#import <QuartzCore/QuartzCore.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    __weak IBOutlet MKMapView *_mapView;
    IBOutlet UIWebView *mapView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    UIView *locateDropdown;
    UIView *searchBarBackground;
    NSNumber* locateVanOptionsPosition;
}

//@property (nonatomic, strong) IBOutlet UIWebView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) IBOutlet UIView*locateDropdown;
@property (nonatomic, strong) NSNumber *locateVanOptionsPosition;
@property (nonatomic, strong) IBOutlet UIView *searchBarBackground;

-(void)plotVegVanStopLocations;
- (void)startStandardUpdates;
-(void)promptForLocationServices;
-(IBAction)showUserLocation:(id)sender;
-(IBAction)dropdownLocateVanOptionsFromButton:(id)sender;
-(void)dropdownLocateVanOptionsWithAnimation:(BOOL)animation;
-(void)positionAndStyleLocateVanDropdown;

@end
