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

#define SPAN_VALUE .05f;//Lowest you can go seems to be 0.001f; in code.


@interface GameMapViewController ()

@end

@implementation GameMapViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Set up a map in code rather than nib
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];//416 - compensate for status & navbar
    [mapView setMapType:0];//create the 'street' type of map, called 'map'. Sat is 1, hybrid is 2.
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setShowsUserLocation:YES];
    
    [self.view addSubview:mapView];
    
    
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
    
    
    CLLocationCoordinate2D location;
    location.latitude = MLI_LATITUDE;
    location.longitude = MLI_LONGITUDE;
    
    AnnotationGameLocation *annotation = [[AnnotationGameLocation alloc] initWithPosition:location];
    annotation.title = @"QUEST1";
    annotation.subtitle = @"GOAL1";
    
    [mapView addAnnotation:annotation];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
