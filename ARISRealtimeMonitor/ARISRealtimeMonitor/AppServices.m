//
//  AppServices.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "AppServices.h"
#import "AppModel.h"

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

- (NSMutableArray *) getGameEvents{
    
     [[AppModel instance] setGameEvents:[[NSMutableArray alloc]init]];
    
    for(int i = 0; i < 3; i++){
        switch (i) {
            case 0:
                [[[AppModel instance] gameEvents] addObject:[[NSMutableArray alloc] initWithObjects:@"Jack Wilshere", @"Theo Walcott", @"Lucas Poldoski", nil]];
                break;
            case 1:
                [[[AppModel instance] gameEvents] addObject:[[NSMutableArray alloc] initWithObjects:@"Gervinho", @"Laurent Kochienly", @"Per Metersacker", nil]];
                break;
            case 2:
                [[[AppModel instance] gameEvents] addObject:[[NSMutableArray alloc] initWithObjects:@"Alex Oxalde-Chamberlain", @"Olivier Giroud", @"Mikel Arteta", nil]];
                break;
                
            default:
                break;
        }
    }
    
    
    return [[AppModel instance] gameEvents];
}

@end
