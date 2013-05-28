//
//  AnnotationGameLocation.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/24/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//
//Help from Lynda tutorial on Mapkit

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationGameLocation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *leftIcon; //could potentially store user avatars.
@property (nonatomic, copy) NSString *icon; // Is this a player or an objective?


-initWithPosition:(CLLocationCoordinate2D)coords;

@end
