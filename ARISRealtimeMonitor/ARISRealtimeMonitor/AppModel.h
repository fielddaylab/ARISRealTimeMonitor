//
//  AppModel.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

@property (nonatomic, strong) NSArray *gamesList;

@property (nonatomic, strong) NSArray *playersList;

@property (nonatomic, strong) NSMutableArray *gameEvents;

+ (AppModel*) instance;

+ (id) allocWithZone:(NSZone *)zone;

@end
