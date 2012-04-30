//
//  FirstViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController
//@synthesize mapView;
@synthesize locationManager, currentLocation;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // for a UIWebView
    //NSString *url = @"https://google-developers.appspot.com/maps/documentation/javascript/examples/map-geolocation";
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[mapView loadRequest:request];
    
    //[self startStandardUpdates];
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500;
    
    [locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        currentLocation = newLocation;
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
    }
    // else skip the event and process the next one.
}

- (void)viewDidUnload
{
    _mapView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 51.751944;
    zoomLocation.longitude= -1.257778;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 3.0*METERS_PER_MILE, 3.0*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];                
    // 4
    [_mapView setRegion:adjustedRegion animated:YES]; 
    
    [self plotVegVanStopLocations];
    
    [_mapView setShowsUserLocation:YES];
    
    [self startStandardUpdates];
    
    [super viewWillAppear:animated];
}

-(IBAction)showNearestStopLocation:(id)sender
{
    CLLocationDistance shortestDistance;
    CLLocationDistance meters;
    NSInteger counter = 0;
    VegVanStopLocation *annotation;
    CLLocation *annotationLocation;
    NSInteger closestAnnotationIndex = 0;
    while (counter < [[_mapView annotations] count])
    {
        annotation = [_mapView.annotations objectAtIndex:counter];
        if (![annotation isKindOfClass:[MKUserLocation class]])
        {
            
            annotationLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
            meters = [currentLocation distanceFromLocation:annotationLocation];
            
            if (counter==0)
            {
                shortestDistance = meters;
            }
            else
            {
                if (meters < shortestDistance)
                {
                    shortestDistance = meters;
                    closestAnnotationIndex = counter;
                }
            }
        }
        counter++;
    }
    
    VegVanStopLocation *nearestAnnotation = [_mapView.annotations objectAtIndex:closestAnnotationIndex];
    
    [_mapView setCenterCoordinate: [nearestAnnotation coordinate] animated:YES];
    [_mapView selectAnnotation:nearestAnnotation animated:YES];
}

-(void)plotVegVanStopLocations
{
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    /*NSDictionary * root = [responseString JSONValue];
    NSArray *data = [root objectForKey:@"data"];
    
    for (NSArray * row in data) {
        
        NSNumber * latitude = [[row objectAtIndex:21]objectAtIndex:1];
        NSNumber * longitude = [[row objectAtIndex:21]objectAtIndex:2];
        NSString * crimeDescription =[row objectAtIndex:17];
        NSString * address = [row objectAtIndex:13];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;            
        MyLocation *annotation = [[MyLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
        [_mapView addAnnotation:annotation];    
    }*/
    
    NSArray *latitudes = [NSArray arrayWithObjects:[NSNumber numberWithDouble:51.752487],
                                                   [NSNumber numberWithDouble:51.743984],
                                                   [NSNumber numberWithDouble:51.753602],
                                                   [NSNumber numberWithDouble:51.758995],
                                                   [NSNumber numberWithDouble:51.764122],nil];
    NSArray *longitudes = [NSArray arrayWithObjects:[NSNumber numberWithDouble:-1.260338],
                          [NSNumber numberWithDouble:-1.235147],
                          [NSNumber numberWithDouble:-1.271281],
                          [NSNumber numberWithDouble:-1.253514],
                          [NSNumber numberWithDouble:-1.268921],nil];
    NSArray *stopNames = [NSArray arrayWithObjects:@"Jericho",@"East Oxford",@"The Castle",@"Summertown",@"Cowley", nil];
    NSArray *addresses = [NSArray arrayWithObjects:@"OX1 3QA",@"OX1 3QA",@"OX1 3QA",@"OX1 3QA",@"OX1 3QA", nil];
    
    for (int i = 0; i<[latitudes count]; i++)
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[latitudes objectAtIndex:i] doubleValue];
        coordinate.longitude = [[longitudes objectAtIndex:i] doubleValue];            
        VegVanStopLocation *annotation = [[VegVanStopLocation alloc] initWithName:[stopNames objectAtIndex:i] address:[addresses objectAtIndex:i] coordinate:coordinate] ;
        [_mapView addAnnotation:annotation]; 
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
    
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark MKMapViewDelegate methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"VegVanstopLocation";   
    if ([annotation isKindOfClass:[VegVanStopLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"136-tractor.png"];
        
        return annotationView;
    }
    
    return nil;    
}

@end
