//
//  AppServices.h
//  ARIS
//
//  Created by David J Gagnon on 5/11/11.
//  Copyright 2011 University of Wisconsin. All rights reserved.
//

#import "ServiceResult.h"

@interface AppServices : NSObject

extern NSString *const kARISServerServicePackage;

+ (AppServices *)sharedAppServices;

//Player
- (void)loginUserName:(NSString *)username password:(NSString *)password userInfo:(NSMutableDictionary *)dict;
- (void)resetAndEmailNewPassword:(NSString *)email;

//Parse server responses
- (NSMutableArray *)parseGameListFromJSON:(ServiceResult *)result;

//ArisRealtimeMonitor
- (void)loginEditorUserName:(NSString *)username password:(NSString *)password userInfo:(NSMutableDictionary *)dict;
- (void)getGamesForEditor:(NSString *)editorId editorToken:(NSString *)editorToken;
- (void)getLocationsForGame:(NSString *)gameId;
- (void)getLocationsOfGamePlayers:(NSString *)gameId;
- (void)getLogsForGame:(NSString *)gameId seconds:(NSString *)seconds;

@end
