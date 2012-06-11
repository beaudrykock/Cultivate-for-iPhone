//
//  FirstViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VegVanStopLocation.h"
#import "FarmAnnotation.h"
#import <QuartzCore/QuartzCore.h>
#import "VegVanStop.h"
#import "ScheduleItemDetailViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, ScheduleItemDetailViewControllerDelegate>
{
    __weak IBOutlet MKMapView *_mapView;
    IBOutlet UIWebView *mapView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    UIView *locateDropdown;
    UIView *searchBarBackground;
    NSNumber* locateVanOptionsPosition;
    UISearchBar *stopSearchBar;
    UIView *touchView;
    ScheduleItemDetailViewController *sidvc;
    UINavigationBar *bar;
    UIButton *findButton;
    UIButton *showUserLocationButton;
    BOOL farmShowing;
    UILabel *nextLabel;
    UILabel *farmLabel;
    UILabel *nearestMeLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *nearestMeLabel;
@property (nonatomic, strong) IBOutlet UILabel *nextLabel;
@property (nonatomic, strong) IBOutlet UILabel *farmLabel;
//@property (nonatomic, strong) IBOutlet UIWebView *mapView;
@property (nonatomic, strong) IBOutlet UINavigationBar *bar;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) IBOutlet UIView*locateDropdown;
@property (nonatomic, strong) NSNumber *locateVanOptionsPosition;
@property (nonatomic, strong) IBOutlet UIView *searchBarBackground;
@property (nonatomic, strong) IBOutlet UISearchBar *stopSearchBar;
@property (nonatomic, strong) UIView *touchView;
@property (nonatomic,strong) ScheduleItemDetailViewController *sidvc;
@property (nonatomic, strong) IBOutlet UIButton* findButton;
@property (nonatomic, strong) IBOutlet UIButton* showUserLocationButton;

-(void)promptForLocationServicesFindMe;
-(void)plotVegVanStopLocations;
- (void)startStandardUpdates;
-(void)promptForLocationServices;
-(IBAction)showUserLocation:(id)sender;
-(IBAction)dropdownLocateVanOptionsFromButton:(id)sender;
-(void)dropdownLocateVanOptionsWithAnimation:(BOOL)animation;
-(void)positionAndStyleLocateVanDropdown;
-(IBAction)showNextStopLocation:(id)sender;
-(IBAction)showNearestStopLocation:(id)sender;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
- (void)registerForKeyboardNotifications;
- (void)hideSIVDC;
-(IBAction)showFarmLocation:(id)sender;
-(void)selectFarmAnnotation:(FarmAnnotation*)annotation;

@end
