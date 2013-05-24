//
//  AnnotationGameLocation.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/24/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "AnnotationGameLocation.h"


@implementation AnnotationGameLocation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


-initWithPosition:(CLLocationCoordinate2D)coords{
    if (self = [super init]){
        self.coordinate = coords;
    }
    return self;
}



@end
