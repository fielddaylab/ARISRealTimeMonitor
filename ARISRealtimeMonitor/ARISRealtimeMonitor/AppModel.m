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

@implementation AppModel

@synthesize serverURL;


//ARIS Realtime Monitor Additions
@synthesize gameEvents, listOfPlayersGames, locations, playersInGame, events, types;

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
	//[defaults synchronize];
    
    NSURL *currServ = [NSURL URLWithString:@""];
    
    if([[currServ absoluteString] isEqual:@""])
    {
        NSString *updatedURL = @"http://dev.arisgames.org/server";
        //[defaults setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:updatedURL] forKey:@"baseServerString"];
        //[defaults synchronize];
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
