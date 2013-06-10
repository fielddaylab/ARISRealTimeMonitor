//
//  AnnotationViews.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/28/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "AnnotationViews.h"

#import "AnnotationGameLocation.h"


@implementation AnnotationViews

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    AnnotationGameLocation *newAnnotation = (AnnotationGameLocation *)annotation;
    
    
    NSString *stringToTest = [newAnnotation description];
    if ([stringToTest rangeOfString:@"MKUserLocation"].location == NSNotFound) {
        //NSLog(@"is not User");

    
    
        NSString *image;
    
        if ([newAnnotation.leftIcon isEqualToString:@"test1"]) {
            image = @"sun.png";
        } else if ([newAnnotation.leftIcon isEqualToString:@"test2"]) {
            image = @"cactus.png";
        }
    
            //setImage:[UIImage imageNamed:@"73-radar.png"]
    
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        self.leftCalloutAccessoryView = imageView;

    
        if ([newAnnotation.icon isEqualToString:@"player"]) {
            self.image = [UIImage imageNamed:@"145-persondot.png"];
        }
        else if ([newAnnotation.icon isEqualToString:@"gameLocation"]){
            self.image = [UIImage imageNamed:@"74-location.png"];
        }
        else{
            self.image = [UIImage imageNamed:@"196-radiation.png"];
            //NSLog(@"Not a player or gameLocation :'[");
        }
    
        //used to test
        newAnnotation.title = @"hello";
    }else {
        //NSLog(@"is User");
        self.image = [UIImage imageNamed:@"sun.png"];
    }
    
    //NSLog(@"annotation: %@",newAnnotation);
       
        
    self.enabled = YES;
    self.canShowCallout = YES;

    return self;
}


@end