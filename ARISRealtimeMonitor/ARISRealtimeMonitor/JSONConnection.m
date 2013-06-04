//
//  JSONConnection.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 6/3/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "JSONConnection.h"
#import "AppServices.h"

@implementation JSONConnection

@synthesize jsonServerURL;
@synthesize serviceName;
@synthesize methodName;
@synthesize arguments;
@synthesize handler;
@synthesize userInfo;
@synthesize completeRequestURL;
@synthesize asyncData;
@synthesize connection;

- (JSONConnection*)initWithServer:(NSURL *)server
                   andServiceName:(NSString *)service
                    andMethodName:(NSString *)method
                     andArguments:(NSArray *)args
                      andUserInfo:(NSMutableDictionary *)auserInfo{
	
	self.jsonServerURL = server;
	self.serviceName = service;
	self.methodName = method;
	self.arguments = args;
	self.userInfo = auserInfo;
    
	//Compute the Arguments
	NSMutableString *requestParameters = [NSMutableString stringWithFormat:@"json.php/%@.%@.%@", kARISServerServicePackage, self.serviceName, self.methodName];
	NSEnumerator *argumentsEnumerator = [self.arguments objectEnumerator];
	NSString *argument;
	while (argument = [argumentsEnumerator nextObject]) {
        
        
		[requestParameters appendString:@"/"];
        // replace special characters
        argument = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                         (__bridge_retained CFStringRef)argument,
                                                                                         NULL,
                                                                                         (CFStringRef)@"!*'();:@&=+$,?%#",
                                                                                         kCFStringEncodingUTF8 );
        
        // double encode slashes (CFURLCreateStringByAddingPercentEscapes doesn't handle them well)
        // actions.php on server side decodes them once before sending these arguments on to their respective functions.
        argument = [argument stringByReplacingOccurrencesOfString:@"/" withString:@"%252F"];
        [requestParameters appendString:argument];
	}
    NSMutableString *serverString = [NSMutableString stringWithString:[server absoluteString]];
    [serverString appendString:@"/"];
    [serverString appendString:requestParameters];
    NSURL *url = [NSURL URLWithString:[serverString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    self.completeRequestURL = url;
    
	NSLog(@"Requesting URL: %@", self.completeRequestURL);
    
	return self;
}

- (void) performAsynchronousRequestWithHandler: (SEL)aHandler{
    //save the handler
    if (aHandler) self.handler = aHandler;
    else self.handler = nil;
	
    //Make sure we were inited correctly
    if (!completeRequestURL) return;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:completeRequestURL];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[self.connection start];
	
	//Set up indicators
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end
