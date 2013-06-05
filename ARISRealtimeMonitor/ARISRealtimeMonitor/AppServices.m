//
//  AppServices.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "AppServices.h"
#import "AppModel.h"
#import "JSONConnection.h"
#import "ARISAlertHandler.h"

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
    //return [[NSArray alloc] initWithObjects:@"Game 1", @"Game 2", @"Game 3", @"Game 4", @"Game 5", @"Game 6", @"Game 7", @"Game 8", @"Game 9", @"Game 10", @"Game 11", nil];
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

#pragma mark Communication with Server
- (void)loginUserName:(NSString *)username password:(NSString *)password userInfo:(NSMutableDictionary *)dict
{
	NSArray *arguments = [NSArray arrayWithObjects:username, password, nil];

	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithServer:[AppModel sharedAppModel].serverURL
                                                             andServiceName:@"players"
                                                              andMethodName:@"getLoginPlayerObject"
                                                               andArguments:arguments
                                                                andUserInfo:dict];
	[jsonConnection performAsynchronousRequestWithHandler:@selector(parseLoginResponseFromJSON:)];
}

-(void)parseLoginResponseFromJSON:(ServiceResult *)result
{
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [responseDict setObject:result forKey:@"result"];
    NSLog(@"NSNotification: LoginResponseReady");
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"LoginResponseReady" object:nil userInfo:responseDict]];
}


-(void)resetAndEmailNewPassword:(NSString *)email
{
    NSArray *arguments = [NSArray arrayWithObjects:
                          email,
						  nil];
	JSONConnection *jsonConnection = [[JSONConnection alloc]
                                      initWithServer:[AppModel sharedAppModel].serverURL
                                      andServiceName:@"players"
                                      andMethodName:@"resetAndEmailNewPassword"
                                      andArguments:arguments
                                      andUserInfo:nil];
	[jsonConnection performAsynchronousRequestWithHandler:
     @selector(parseResetAndEmailNewPassword:)];
}

-(void)parseResetAndEmailNewPassword:(ServiceResult *)jsonResult
{
    if(jsonResult == nil)
        [[ARISAlertHandler sharedAlertHandler] showAlertWithTitle:NSLocalizedString(@"Invalid Email Address", nil) message:NSLocalizedString(@"Please enter the email address associated with your game account in order to recover your password.", nil)];
    else
        [[ARISAlertHandler sharedAlertHandler] showAlertWithTitle:NSLocalizedString(@"Email Sent", @"") message:NSLocalizedString(@"An email has been sent to you with instructions for changing your password", @"")];
}


@end
