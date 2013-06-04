//
//  JSONConnection.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 6/3/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServiceResult;

@interface JSONConnection : NSObject <NSURLConnectionDelegate>{
	NSURL *jsonServerURL;
	NSString *serviceName;
	NSString *methodName;
	NSArray *arguments;
    SEL handler;
    NSMutableDictionary *userInfo;
	NSMutableData *asyncData;
	NSURL *completeRequestURL;
    NSURLConnection *connection;
}

@property(nonatomic) NSURL *jsonServerURL;
@property(nonatomic) NSString *serviceName;
@property(nonatomic) NSString *methodName;
@property(nonatomic) NSArray *arguments;
@property(nonatomic) SEL handler;
@property(nonatomic) NSMutableDictionary *userInfo;
@property(nonatomic) NSURL *completeRequestURL;
@property(nonatomic) NSMutableData *asyncData;
@property(nonatomic) NSURLConnection *connection;

- (JSONConnection*)initWithServer: (NSURL *)server
                   andServiceName:(NSString *)serviceName
					andMethodName:(NSString *)methodName
                     andArguments:(NSArray *)arguments
                      andUserInfo:(NSMutableDictionary *)userInfo;

- (void) performAsynchronousRequestWithHandler: (SEL)handler;

@end
