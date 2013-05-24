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

- (void)viewDidLoad
{
    
    // Do any additional setup after loading the view from its nib.
    
    //Set up a map in code rather than nib
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];//416 - compensate for status & navbar
    [self.mapView setMapType:0];//create the 'street' type of map, called 'map'. Sat is 1, hybrid is 2.
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setShowsUserLocation:YES];
    
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
    
    //Create an annotation on the map.
    CLLocationCoordinate2D location;
    location.latitude = HOME_LATITUDE;
    location.longitude = HOME_LONGITUDE;
    
    AnnotationGameLocation *annotation = [[AnnotationGameLocation alloc] initWithPosition:location];
    annotation.title = @"QUEST1";
    annotation.subtitle = @"GOAL1";
    
    [self.mapView addAnnotation:annotation];
    
    
    //used to get the actual location
    self.mapView.delegate = self;
    
    //[self.mapView setShowsUserLocation:YES];//Shouldn't need since called earlier.
    [super viewDidLoad];
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //Lets us define a region based on the users location. If we want a defined location, use above code instead.

    NSLog(@"didUpdateUserLocation was called");
    /*//iPhone Forum
    MKCoordinateRegion region;
	
	region.span.latitudeDelta = .005;
	region.span.longitudeDelta = .005;
	region.center = userLocation.coordinate;
	
	[mapView setRegion:region animated:YES];
    */
    //Lynda code
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
