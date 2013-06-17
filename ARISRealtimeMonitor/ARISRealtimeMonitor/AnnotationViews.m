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
    if ([stringToTest rangeOfString:@"MKUserLocation"].location == NSNotFound) { //may not need
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

    
        if ([newAnnotation.icon isEqualToString:@"Player"]) {
            self.image = [UIImage imageNamed:@"145-persondot.png"];
            newAnnotation.title = @"Player";
        }
        else if ([newAnnotation.icon isEqualToString:@"Item"]){
            self.image = [UIImage imageNamed:@"257-box3.png"];
            //newAnnotation.title = @"Item";
        }
        else if ([newAnnotation.icon isEqualToString:@"Node"]){
            self.image = [UIImage imageNamed:@"55-network.png"];
            //newAnnotation.title = @"Node";
        }
        else if ([newAnnotation.icon isEqualToString:@"Npc"]){
            self.image = [UIImage imageNamed:@"111-user.png"];
            //newAnnotation.title = @"Npc";
        }
        else if ([newAnnotation.icon isEqualToString:@"WebPage"]){
            self.image = [UIImage imageNamed:@"174-imac.png"];
            //newAnnotation.title = @"WebPage";
        }
        else if ([newAnnotation.icon isEqualToString:@"AugBubble"]){
            self.image = [UIImage imageNamed:@"08-chat.png"];
            //newAnnotation.title = @"AugBubble";
        }
        else if ([newAnnotation.icon isEqualToString:@"PlayerNote"]){
            self.image = [UIImage imageNamed:@"notebook.png"];
            //newAnnotation.title = @"PlayerNote";
        }
        else{
            self.image = [UIImage imageNamed:@"196-radiation.png"];
            newAnnotation.title = @"Error :'[";
        }
        
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