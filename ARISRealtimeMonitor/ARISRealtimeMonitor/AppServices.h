//
//  AppServices.h
//  ARIS
//
//  Created by David J Gagnon on 5/11/11.
//  Copyright 2011 University of Wisconsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"
#import "Location.h"
#import "Game.h"
#import "ServiceResult.h"
#import "JSONConnection.h"
#import "ServiceResult.h"
#import "JSON.h"


@interface AppServices : NSObject

extern NSString *const kARISServerServicePackage;

+ (AppServices *)sharedAppServices;

//Player
- (void)loginUserName:(NSString *)username password:(NSString *)password userInfo:(NSMutableDictionary *)dict;
- (void)resetAndEmailNewPassword:(NSString *)email;






//Parse server responses
- (NSMutableArray *)parseGameListFromJSON:(ServiceResult *)result;


//ArisRealtimeMonitor
//this is a placeholder for retrieving the events list from the server
- (NSMutableArray *) getGameEvents;
- (void)loginEditorUserName:(NSString *)username password:(NSString *)password userInfo:(NSMutableDictionary *)dict;
- (void)getGamesForEditor:(NSString *)editorId editorToken:(NSString *)editorToken;
- (void)getLocationsForGame:(NSString *)gameId;
-(void)getLocationsOfGamePlayers:(NSString *)gameId;
-(void)getLogsForGame:(NSString *)gameId seconds:(NSString *)seconds;

@end
