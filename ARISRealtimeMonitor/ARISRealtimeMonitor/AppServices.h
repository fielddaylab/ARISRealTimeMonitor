//
//  AppServices.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppServices : NSObject

+ (AppServices *) sharedAppServices;

//this is a placeholder for retrieving the games list from the server
- (NSArray *) getGamesList;
//this is a placeholder for retrieving the players list from the server
- (NSArray *) getPlayersList;
//this is a placeholder for retrieving the events list from the server
- (NSMutableArray *) getGameEventsForGame:(NSInteger)game;

@end
