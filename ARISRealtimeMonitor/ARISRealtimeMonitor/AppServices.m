//
//  AppServices.m
//  ARIS
//
//  Created by David J Gagnon on 5/11/11.
//  Copyright 2011 University of Wisconsin. All rights reserved.
//

#import "AppServices.h"
#import "NSDictionary+ValidParsers.h"
#import "ARISAlertHandler.h"
#import "Event.h"

NSString *const kARISServerServicePackage = @"v1";



@implementation AppServices

+ (id)sharedAppServices
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
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
    //make these localized
    if(jsonResult == nil)
        [[ARISAlertHandler sharedAlertHandler] showAlertWithTitle:NSLocalizedString(@"FailureForgotPasswordTitleKey", nil) message:NSLocalizedString(@"ForgotPasswordMessageKey", nil)];
    else
        [[ARISAlertHandler sharedAlertHandler] showAlertWithTitle:NSLocalizedString(@"SuccessForgotEmailSentTitleKey", @"") message:NSLocalizedString(@"ForgotMessageKey", @"")];
}


- (Game *)parseGame:(NSDictionary *)gameSource
{
    Game *game = [[Game alloc] init];
    
    game.gameId                   = [gameSource validIntForKey:@"game_id"];
    game.hasBeenPlayed            = [gameSource validBoolForKey:@"has_been_played"];
    game.isLocational             = [gameSource validBoolForKey:@"is_locational"];
    game.showPlayerLocation       = [gameSource validBoolForKey:@"show_player_location"];
    //game.inventoryModel.weightCap = [gameSource validIntForKey:@"inventory_weight_cap"];
    game.rating                   = [gameSource validIntForKey:@"rating"];
    game.pcMediaId                = [gameSource validIntForKey:@"pc_media_id"];
    game.numPlayers               = [gameSource validIntForKey:@"numPlayers"];
    game.playerCount              = [gameSource validIntForKey:@"count"];
    game.gdescription             = [gameSource validStringForKey:@"description"];
    game.name                     = [gameSource validStringForKey:@"name"];
    game.authors                  = [gameSource validStringForKey:@"editors"];
    game.mapType                  = [gameSource validObjectForKey:@"map_type"];
    if (!game.mapType || (![game.mapType isEqualToString:@"STREET"] && ![game.mapType isEqualToString:@"SATELLITE"] && ![game.mapType isEqualToString:@"HYBRID"])) game.mapType = @"STREET";

    NSString *distance = [gameSource validObjectForKey:@"distance"];
    if (distance) game.distanceFromPlayer = [distance doubleValue];
    else game.distanceFromPlayer = 999999999;
    
    NSString *latitude  = [gameSource validObjectForKey:@"latitude"];
    NSString *longitude = [gameSource validObjectForKey:@"longitude"];
    if (latitude && longitude)
        game.location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    else
        game.location = [[CLLocation alloc] init];
    
//    int iconMediaId;
//    if((iconMediaId = [gameSource validIntForKey:@"icon_media_id"]) > 0)
//    {
//        game.iconMedia = [[AppModel sharedAppModel] mediaForMediaId:iconMediaId];
//        game.iconMedia.type = @"PHOTO"; //Phil doesn't like this...
//    }
    
    
//    int mediaId;
//    if((mediaId = [gameSource validIntForKey:@"media_id"]) > 0)
//    {
//        game.splashMedia = [[AppModel sharedAppModel] mediaForMediaId:mediaId];
//        game.splashMedia.type = @"PHOTO"; //Phil doesn't like this...
//    }

    
    //game.questsModel.totalQuestsInGame = [gameSource validIntForKey:@"totalQuests"];
    game.launchNodeId                  = [gameSource validIntForKey:@"on_launch_node_id"];
    game.completeNodeId                = [gameSource validIntForKey:@"game_complete_node_id"];
    game.calculatedScore               = [gameSource validIntForKey:@"calculatedScore"];
    game.numReviews                    = [gameSource validIntForKey:@"numComments"];
    game.allowsPlayerTags              = [gameSource validBoolForKey:@"allow_player_tags"];
    game.allowShareNoteToMap           = [gameSource validBoolForKey:@"allow_share_note_to_map"];
    game.allowShareNoteToList          = [gameSource validBoolForKey:@"allow_share_note_to_book"];
    game.allowNoteComments             = [gameSource validBoolForKey:@"allow_note_comments"];
    game.allowNoteLikes                = [gameSource validBoolForKey:@"allow_note_likes"];
    game.allowTrading                  = [gameSource validBoolForKey:@"allow_trading"];
    
//    NSArray *comments = [gameSource validObjectForKey:@"comments"];
//    for (NSDictionary *comment in comments)
//    {
//        //This is returning an object with playerId,tex, and rating. Right now, we just want the text
//        Comment *c = [[Comment alloc] init];
//        c.text = [comment validObjectForKey:@"text"];
//        c.playerName = [comment validObjectForKey:@"username"];
//        NSString *cRating = [comment validObjectForKey:@"rating"];
//        if (cRating) c.rating = [cRating intValue];
//        [game.comments addObject:c];
//    }
    
    return game;
}

-(NSMutableArray *)parseGameListFromJSON:(ServiceResult *)jsonResult
{
    NSArray *gameListArray = (NSArray *)jsonResult.data;
    
    NSMutableArray *tempGameList = [[NSMutableArray alloc] init];
    
    NSEnumerator *gameListEnumerator = [gameListArray objectEnumerator];
    NSDictionary *gameDictionary;
    while ((gameDictionary = [gameListEnumerator nextObject])) {
        [tempGameList addObject:[self parseGame:(gameDictionary)]];
    }
    
//    NSError *error;
//    if (![[AppModel sharedAppModel].mediaCache.context save:&error])
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);

    return tempGameList;
}


//placeholder. needs to change
- (NSMutableArray *) getGameEvents{
    return [[NSMutableArray alloc] initWithObjects:@"Jack Wilshere", @"Theo Walcott", @"Lucas Poldoski", nil];
}

- (void)loginEditorUserName:(NSString *)username password:(NSString *)password userInfo:(NSMutableDictionary *)dict
{
	NSArray *arguments = [NSArray arrayWithObjects:username, password, @"read_write", nil];
    
	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithServer:[AppModel sharedAppModel].serverURL
                                                             andServiceName:@"editors"
                                                              andMethodName:@"getToken"
                                                               andArguments:arguments
                                                                andUserInfo:dict];
	[jsonConnection performAsynchronousRequestWithHandler:@selector(parseEditorLoginResponseFromJSON:)];
}

-(void)parseEditorLoginResponseFromJSON:(ServiceResult *)result
{
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    if(result != nil){
        [responseDict setObject:result forKey:@"result"];
    }
    NSLog(@"NSNotification: LoginEditorResponseReady");
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"LoginEditorResponseReady" object:nil userInfo:responseDict]];
}

- (void)getGamesForEditor:(NSString *)editorId editorToken:(NSString *)editorToken{
    NSArray *arguments = [NSArray arrayWithObjects:editorId, editorToken, nil];
    
	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithServer:[AppModel sharedAppModel].serverURL
                                                             andServiceName:@"games"
                                                              andMethodName:@"getGamesForEditor"
                                                               andArguments:arguments
                                                                andUserInfo:nil];
	[jsonConnection performAsynchronousRequestWithHandler:@selector(parseGetGamesForEditor:)];
}


-(void)parseGetGamesForEditor:(ServiceResult *)jsonResult
{
    NSLog(@"parseGetGamesForEditor");
    
    [AppModel sharedAppModel].listOfPlayersGames = [self parseGameListFromJSON:jsonResult];
    NSLog(@"NSNotification: GamesListReady");
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GamesListReady" object:nil]];
}

- (void)getLocationsForGame:(NSString *)gameId{
    NSArray *arguments = [NSArray arrayWithObjects:gameId, nil];
    
	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithServer:[AppModel sharedAppModel].serverURL
                                                             andServiceName:@"locations"
                                                              andMethodName:@"getLocations"
                                                               andArguments:arguments
                                                                andUserInfo:nil];
	[jsonConnection performAsynchronousRequestWithHandler:@selector(parseLocationListEditorFromJSON:)];
}

- (void)parseLocationListEditorFromJSON:(ServiceResult *)jsonResult
{
	NSArray *locationsArray = (NSArray *)jsonResult.data;
    NSLog(@"parseLocationListEditorFromJSON");
    
	//Build the location list
	NSMutableDictionary *tempLocationsList = [[NSMutableDictionary alloc] init];
	NSEnumerator *locationsEnumerator = [locationsArray objectEnumerator];
	NSDictionary *locationDictionary;
	while ((locationDictionary = [locationsEnumerator nextObject])){
        Location *tempLocation = [[Location alloc] initWithDictionary:locationDictionary];
        NSString *key = [NSString stringWithFormat:@"%i", tempLocation.locationId];
        [tempLocationsList setObject:tempLocation forKey:key];
    }
    
    [AppModel sharedAppModel].locations = tempLocationsList;
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CreateAnnotations" object:nil userInfo:nil]];
}

-(void)getLocationsOfGamePlayers:(NSString *)gameId{
    NSArray *arguments = [NSArray arrayWithObjects:gameId, @"0", nil];
    
	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithServer:[AppModel sharedAppModel].serverURL
                                                             andServiceName:@"players"
                                                              andMethodName:@"getOtherPlayersForGame"
                                                               andArguments:arguments
                                                                andUserInfo:nil];
	[jsonConnection performAsynchronousRequestWithHandler:@selector(parseLocationsOfGamePlayersFromJSON:)];
}

-(void)parseLocationsOfGamePlayersFromJSON:(ServiceResult *)jsonResult{
    NSArray *playersArray = (NSArray *)jsonResult.data;
    NSMutableDictionary *tempPlayersList = [[NSMutableDictionary alloc] init];
    NSEnumerator *playersEnumerator = [playersArray objectEnumerator];
    NSDictionary *playersDictionary;
    while((playersDictionary = [playersEnumerator nextObject])){
        //this isnt going to construct a complete Player object because only the id and location are returned from the server. we can grab the rest later
        Player *tempPlayer = [[Player alloc] initWithDictionary:playersDictionary];
        NSString *key = [NSString stringWithFormat:@"%i", tempPlayer.playerId];
        [tempPlayersList setObject: tempPlayer forKey:key];
    }
    
    [AppModel sharedAppModel].playersInGame = tempPlayersList;
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CreatePlayerLocations" object:nil userInfo:nil]];
}

-(void)getLogsForGame:(NSString *)gameId seconds:(NSString *)seconds{
    NSArray *arguments = [NSArray arrayWithObjects:gameId, seconds, nil];
    
	JSONConnection *jsonConnection = [[JSONConnection alloc] initWithServer:[AppModel sharedAppModel].serverURL
                                                             andServiceName:@"games"
                                                              andMethodName:@"getReadablePlayerLogsForGame"
                                                               andArguments:arguments
                                                                andUserInfo:nil];
	[jsonConnection performAsynchronousRequestWithHandler:@selector(parseLogsFromGameFromJSON:)];
}

-(void)parseLogsFromGameFromJSON:(ServiceResult *)jsonResult{
    NSLog(@"parseLogsFromGameFromJSON");
    NSArray *logsArray = (NSArray *)jsonResult.data;
    NSEnumerator *eventEnumerator = [logsArray objectEnumerator];
    NSDictionary *eventsDictionary;
    while((eventsDictionary = [eventEnumerator nextObject])){
        Event *tempEvent = [[Event alloc] initWithDictionary:eventsDictionary];
        [[[AppModel sharedAppModel] events] insertObject:tempEvent atIndex:0];
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"EventsReady" object:nil userInfo:nil]];
}



@end
