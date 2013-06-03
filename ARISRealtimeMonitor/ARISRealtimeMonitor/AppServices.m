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

NSString *const kARISServerServicePackage = @"v1";

+ (AppServices*) sharedAppServices {
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (NSArray *) getGamesList{
    return [[NSArray alloc] initWithObjects:@"Game 1", @"Game 2", @"Game 3", nil];
}

- (NSArray *) getPlayersList{
    return [[NSArray alloc] initWithObjects:@"4 Players", @"0 Players", @"0 Players", nil];
}

- (NSMutableArray *) getGameEventsForGame:(NSInteger)game{

        switch (game) {
            case 0:
                return [[NSMutableArray alloc] initWithObjects:@"Jack Wilshere", @"Theo Walcott", @"Lucas Poldoski", nil];
            case 1:
                return [[NSMutableArray alloc] initWithObjects:@"Gervinho", @"Laurent Kochienly", @"Per Metersacker", nil];
            case 2:
                return [[NSMutableArray alloc] initWithObjects:@"Alex Oxlade-Chamberlain", @"Olivier Giroud", @"Mikel Arteta", nil];
                
            default:
                break;
        }
    
    
    return nil;
}

@end
