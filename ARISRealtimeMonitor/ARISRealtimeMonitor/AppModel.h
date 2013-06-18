//
//  AppModel.h
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreData/CoreData.h>
#import "Game.h"
#import "Location.h"
#import "Player.h"

@interface AppModel : NSObject <UIAccelerometerDelegate>

@property(nonatomic, strong) NSURL *serverURL;


//ARIS Realtime Monitor additions
@property (nonatomic, strong) NSMutableArray *listOfPlayersGames;
@property (nonatomic, strong) NSMutableDictionary *locations;

@property (nonatomic, strong) NSMutableDictionary *types;

@property (nonatomic, strong) NSMutableDictionary *playersInGame;
//this is a placeholder for the game events
@property (nonatomic, strong) NSMutableArray *gameEvents;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic) MKCoordinateRegion region;

+ (AppModel *)sharedAppModel;
-(void)loadUserDefaults;

@end
