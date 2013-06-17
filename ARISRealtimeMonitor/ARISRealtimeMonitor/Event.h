//
//  Event.h
//  ARIS
//
//  Created by Justin Moeller on 6/10/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *eventType;
//change this to a timestamp data structure
@property (nonatomic, strong) NSString *timestamp;
@property(nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *eventDetail1;


- (id) initWithDictionary:(NSDictionary *)dict;

@end
