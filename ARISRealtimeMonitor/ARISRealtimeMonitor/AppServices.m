//
//  AppServices.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "AppServices.h"

@implementation AppServices

+ (AppServices*) instance {
    static dispatch_once_t _singletonPredicate;
    static AppServices *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    
    return _singleton;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self instance];
}

- (NSArray *) getGamesList{
    return [[NSArray alloc] initWithObjects:@"Game 1", @"Game 2", @"Game 3", nil];
}

- (NSArray *) getPlayersList{
    return [[NSArray alloc] initWithObjects:@"4 Players", @"0 Players", @"0 Players", nil];
}

@end
