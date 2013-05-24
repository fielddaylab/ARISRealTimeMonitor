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
    NSLog(@"viewDidAppear");
    [self.mapView setShowsUserLocation:YES];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    //Set up a map in code rather than nib
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];//416 - compensate for status & navbar
    [self.mapView setMapType:0];//create the 'street' type of map, called 'map'. Sat is 1, hybrid is 2.
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    [self.view addSubview:self.mapView];
    
    /*//Used if we want to have a predefined region.
    //Set up to start at specific location
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
    [annotations addObject:annotation];
    
    location.latitude = HOME_LATITUDE;
    location.longitude = HOME_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST2 HOME";
    annotation.subtitle = @"GOAL2 HOME";
    [annotations addObject:annotation];
    
    location.latitude = CS_LATITUDE;
    location.longitude = CS_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST3 CS";
    annotation.subtitle = @"GOAL3 CS";
    [annotations addObject:annotation];
    
    location.latitude = TERRACE_LATITUDE;
    location.longitude = TERRACE_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST4 TERRACE";
    annotation.subtitle = @"GOAL4 TERRACE";
    [annotations addObject:annotation];
    
    location.latitude = USOUTH_LATITUDE;
    location.longitude = USOUTH_LONGITUDE;
    annotation = [[AnnotationGameLocation alloc] init];
    [annotation setCoordinate:location];
    annotation.title = @"QUEST5 USOUTH";
    annotation.subtitle = @"GOAL5 USOUTH";
    [annotations addObject:annotation];
    
    [self.mapView addAnnotations:annotations];
    
    //used to get the actual location
    self.mapView.delegate = self;
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //Used for efficiency. If we have a lot of pins, reuse them.
    MKAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if(view == nil){
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    }
    
    //Add right/left images/buttons here if we so choose.
    
    
    return view;
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //Lets us define a region based on the users location. If we want a defined location, use above code instead.

    NSLog(@"didUpdateUserLocation was called");

    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
    [self.mapView setRegion:region animated:YES];
     
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
