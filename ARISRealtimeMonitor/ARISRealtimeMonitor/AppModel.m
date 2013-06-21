//
//  AppModel.m
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "AppModel.h"
#import "Player.h"
#import "AppServices.h"
#import "ARISAlertHandler.h"
#import "Game.h"
#import "Location.h"
#import "Player.h"


@implementation AppModel

@synthesize serverURL;
@synthesize listOfPlayersGames, locations, playersInGame, events, types, region;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
    
    NSString *stringURL =[defaults stringForKey:@"baseServerString"];
    NSURL *currServ = [NSURL URLWithString:stringURL];
    
    if(currServ == nil)
    {
        NSString *updatedURL = @"http://arisgames.org/server";
        [defaults setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:updatedURL] forKey:@"baseServerString"];
        [defaults synchronize];
        currServ = [NSURL URLWithString:updatedURL];
    }
    if(self.serverURL && ![currServ isEqual:self.serverURL])
    {
        //[[AppModel sharedAppModel].mediaCache clearCache];
        NSLog(@"NSNotification: LogoutRequested");
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"LogoutRequested" object:self]];
        self.serverURL = currServ;
        return;
    }
    self.serverURL = currServ;

}

@end
