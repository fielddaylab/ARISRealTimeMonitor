//
//  AppModel.h
//  ARIS
//
//  Created by Ben Longoria on 2/17/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import <CoreLocation/CLLocation.h>
#import <MapKit/MapKit.h>


@interface AppModel : NSObject <UIAccelerometerDelegate>{

}

@property(nonatomic, strong) NSURL *serverURL;
@property (nonatomic, strong) NSMutableArray *listOfPlayersGames;
@property (nonatomic, strong) NSMutableDictionary *locations;
@property (nonatomic, strong) NSMutableDictionary *types;
@property (nonatomic, strong) NSMutableDictionary *playersInGame;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic) MKCoordinateRegion region;

+ (AppModel *)sharedAppModel;
-(void)loadUserDefaults;

@end
