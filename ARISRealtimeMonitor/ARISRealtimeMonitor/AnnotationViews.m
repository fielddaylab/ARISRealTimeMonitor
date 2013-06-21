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
    
        if ([newAnnotation.icon isEqualToString:@"Player"]) {
            self.image = [UIImage imageNamed:@"145-persondot.png"];
        }
        else if ([newAnnotation.icon isEqualToString:@"Item"]){
            self.image = [UIImage imageNamed:@"257-box3.png"];
        }
        else if ([newAnnotation.icon isEqualToString:@"Node"]){
            self.image = [UIImage imageNamed:@"55-network.png"];
        }
        else if ([newAnnotation.icon isEqualToString:@"Npc"]){
            self.image = [UIImage imageNamed:@"111-user.png"];
        }
        else if ([newAnnotation.icon isEqualToString:@"WebPage"]){
            self.image = [UIImage imageNamed:@"174-imac.png"];
        }
        else if ([newAnnotation.icon isEqualToString:@"AugBubble"]){
            self.image = [UIImage imageNamed:@"08-chat.png"];
        }
        else if ([newAnnotation.icon isEqualToString:@"PlayerNote"]){
            self.image = [UIImage imageNamed:@"notebook.png"];
        }
        else{
            self.image = [UIImage imageNamed:@"196-radiation.png"];
        }
        
    }else {
        self.image = [UIImage imageNamed:@"sun.png"];
    }
        
    self.enabled = YES;
    self.canShowCallout = YES;

    return self;
}


@end