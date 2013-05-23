//
//  AppServices.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppServices : NSObject

+ (AppServices*) instance;

+ (id) allocWithZone:(NSZone *)zone;

//this is a placeholder for retrieving the games list from the server
- (NSArray *) getGamesList;
//this is a placeholder for retrieving the players list from the server
- (NSArray *) getPlayersList;

@end
