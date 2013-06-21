//
//  AnnotationViews.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/28/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "AnnotationViews.h"

@implementation AnnotationViews

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
     
    self.enabled = YES;
    self.canShowCallout = YES;

    return self;
}

@end