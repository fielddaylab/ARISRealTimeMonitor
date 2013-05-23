//
//  AppModel.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

@synthesize gamesList, playersList;

+ (AppModel*) instance {
    static dispatch_once_t _singletonPredicate;
    static AppModel *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    
    return _singleton;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self instance];
}


@end
