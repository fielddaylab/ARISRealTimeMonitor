//
//  GameMapViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameMapViewController.h"
#import <MapKit/MapKit.h>
#import "AnnotationGameLocation.h"
#import "AnnotationViews.h"

#define MLI_LATITUDE 43.074789;
#define MLI_LONGITUDE -89.408197;

#define HOME_LATITUDE 43.068182;
#define HOME_LONGITUDE -89.406033;

#define CS_LATITUDE 43.071545;
#define CS_LONGITUDE -89.406685;

#define TERRACE_LATITUDE 43.076894;
#define TERRACE_LONGITUDE -89.399711;

#define USOUTH_LATITUDE 43.071976;
#define USOUTH_LONGITUDE -89.408433;

#define SPAN_VALUE .01f;//Lowest you can go seems to be 0.001f; in code.


@interface GameMapViewController ()
@end

@implementation GameMapViewController
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.mapView setShowsUserLocation:YES];
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    AnnotationGameLocation *annotation;
    
    //more efficient to add all at once
    location.latitude = MLI_LATITUDE;
    location.longitude = MLI_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST1 MLI";
    annotation.subtitle = @"GOAL1 MLI";
    annotation.leftIcon = @"test1";
    annotation.icon = @"player";
    [annotations addObject:annotation];
    
    location.latitude = HOME_LATITUDE;
    location.longitude = HOME_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST2 HOME";
    annotation.subtitle = @"GOAL2 HOME";
    annotation.leftIcon = @"test1";
    annotation.icon = @"gameLocation";
    [annotations addObject:annotation];
    
    location.latitude = CS_LATITUDE;
    location.longitude = CS_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST3 CS";
    annotation.subtitle = @"GOAL3 CS";
    annotation.leftIcon = @"test1";
    annotation.icon = @"player";
    [annotations addObject:annotation];
    
    location.latitude = TERRACE_LATITUDE;
    location.longitude = TERRACE_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST4 TERRACE";
    annotation.subtitle = @"GOAL4 TERRACE";
    annotation.leftIcon = @"test2";
    annotation.icon = @"player";
    [annotations addObject:annotation];
    
    location.latitude = USOUTH_LATITUDE;
    location.longitude = USOUTH_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST5 USOUTH";
    annotation.subtitle = @"GOAL5 USOUTH";
    annotation.leftIcon = @"test2";
    annotation.icon = @"notplayer";
    [annotations addObject:annotation];
    
    [self.mapView addAnnotations:annotations];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-88)];//-88 to compensate for the navbar and status bar
        
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.mapView setMapType:0];//create the 'street' type of map, called 'map'. Sat is 1, hybrid is 2.
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    [self.view addSubview:self.mapView];
    
    
    //Will have to do something like:
    //find highest/lowest lats, find the middle.
    //find rightmost/leftmost longs, find the middle.
    //have the center be those longs/lats.
    //have the span be deltas of those? ->will have to look this up. //can have huge one to debug.
    
    /*//Used if we want to have a predefined region.
    MKCoordinateRegion region;
    CLLocationCoordinate2D center;
    center.latitude = MLI_LATITUDE;
    center.longitude = MLI_LONGITUDE;
    MKCoordinateSpan span;//Zoom
    span.latitudeDelta = SPAN_VALUE;
    span.longitudeDelta = SPAN_VALUE;
    region.center = center;
    region.span = span;
    [mapView setRegion:region animated:YES];
    */

    //used to get the actual location
    self.mapView.delegate = self;
    
    [self setUpButtonsInMap];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    [self setUpButtonsInMap];
}

- (CGRect)getScreenFrameForCurrentOrientation {
    return [self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        temp.size.height += 12; // Offset by 12 because status/navbar change when in landscape.
        fullScreenRect = temp;
    }
    
    return fullScreenRect;
}


- (void) setUpButtonsInMap{
    
    CGRect rec = [self getScreenFrameForCurrentOrientation];

    //Set up the centerizer using a custom image.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(rec.size.width -50, rec.size.height -112, 44, 44)];
    [button setImage:[UIImage imageNamed:@"246-route.png"] forState:UIControlStateNormal];
    [button addTarget:self
               action:nil//@selector(flipView)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];

//     If want to use a default button for the cneterizer
//     UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//     [button addTarget:self
//     action:nil//@selector(aMethod:)
//     forControlEvents:UIControlEventTouchUpInside];
//     [button setTitle:@"Swap" forState:UIControlStateNormal];
//
//     //Try to have off by 6 from border. 44-6 for width; 44navbar, 44button, 18? status bar, 6 for offset.
//     button.frame = CGRectMake(rec.size.width - 50, rec.size.height - (44+44+24),44.0, 44.0);
//    
//     [self.view addSubview:button];
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    /*Does not work with multiple pin icons, since it tries to replace them :'[
    //Will have to give different identifiers for the different image styles zB 'pin'
    //Used for efficiency. If we have a lot of pins, reuse them.
    AnnotationViews *view = (AnnotationViews *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if(view == nil){
        view = [[AnnotationViews alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    }
    */
    
    AnnotationViews *view = [[AnnotationViews alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    //Add right/left images/buttons in AnnotationViews
    
    
    return view;
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //Lets us define a region based on the users location. If we want a defined location, use above code instead.

    NSLog(@"didUpdateUserLocation was called");

    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [self.mapView setRegion:region animated:NO];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
