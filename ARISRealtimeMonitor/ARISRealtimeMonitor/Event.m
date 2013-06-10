//
//  Event.m
//  ARIS
//
//  Created by Justin Moeller on 6/10/13.
//
//

#import "Event.h"
#import "NSDictionary+ValidParsers.h"

@implementation Event


@synthesize location;
@synthesize eventType;
@synthesize timestamp;
@synthesize username;

- (id) initWithDictionary:(NSDictionary *)dict{
    
    if(self = [super init])
    {
		self.eventType = [dict validStringForKey:@"event_type"];
        self.timestamp     = [dict validStringForKey:@"timestamp"];
        self.username = [dict validStringForKey:@"user_name"];
//        if([dict validObjectForKey:@"latitude"] && [dict validObjectForKey:@"longitude"])
//            self.location = [[CLLocation alloc] initWithLatitude:[dict validFloatForKey:@"latitude"] longitude:[dict validFloatForKey:@"longitude"]];
        
    }
    return self;
    
    
}

@end
