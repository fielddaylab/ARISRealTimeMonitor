//
//  GameMapViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//


#import <MapKit/MapKit.h>
#import "Game.h"

@interface GameMapViewController : UIViewController <MKMapViewDelegate>

@property (retain, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) Game *game;
@property (nonatomic) BOOL shouldZoom;
@property NSInteger mapType;
@property BOOL didIFlip;

@end