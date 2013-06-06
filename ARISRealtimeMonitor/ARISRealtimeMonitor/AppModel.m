//
//  AppModel.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

@synthesize gamesList, playersList, gameEvents, listOfPlayersGames;

@synthesize serverURL;

+ (id)sharedAppModel
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

#pragma mark User Defaults

-(void)loadUserDefaults
{
	NSLog(@"Model: Loading User Defaults");
    
    NSURL *currServ = [NSURL URLWithString:@""];
    
    if([[currServ absoluteString] isEqual:@""])
    {
        NSString *updatedURL = @"http://dev.arisgames.org/server";
        currServ = [NSURL URLWithString:updatedURL];
    }
    self.serverURL = currServ;
}


@end
