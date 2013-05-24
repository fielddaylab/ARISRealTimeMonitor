//
//  GameMapViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameViewController.h"

#import <MapKit/MapKit.h>

//Have MKMAPVIEWDLEEGATE so that we can get messages passed to us
@interface GameMapViewController : UIViewController <MKMapViewDelegate>

@property (retain, nonatomic) MKMapView *mapView;

@end