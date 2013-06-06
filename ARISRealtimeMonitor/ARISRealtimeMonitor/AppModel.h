//
//  AppModel.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

@property (nonatomic, strong) NSMutableArray *listOfPlayersGames;

@property (nonatomic, strong) NSMutableArray *gameEvents;

@property(nonatomic, strong) NSURL *serverURL;

+ (AppModel *)sharedAppModel;

- (void) loadUserDefaults;

@end
