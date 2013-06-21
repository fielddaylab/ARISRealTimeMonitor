//
//  GameMapViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameMapViewController.h"
#import "GameViewController.h"
#import "AnnotationGameLocation.h"
#import "AnnotationViews.h"
#import "AppServices.h"
#import "AppModel.h"
#import "Game.h"
#import "Location.h"
#import "Player.h"
#import "JSON.h"


@interface GameMapViewController ()
@end

@implementation GameMapViewController
@synthesize mapView = _mapView;
@synthesize game;
@synthesize shouldZoom;
@synthesize mapType;
@synthesize didIFlip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void) createAnnotations:(NSNotification *)n{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CreateAnnotations" object:nil];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    AnnotationGameLocation *annotation;
    
    for(id key in [AppModel sharedAppModel].locations){
        Location *tempLocation = [[AppModel sharedAppModel].locations objectForKey:key];
        location.latitude = tempLocation.latlon.coordinate.latitude;
        location.longitude = tempLocation.latlon.coordinate.longitude;
        annotation = [[AnnotationGameLocation alloc] init];
        [annotation setCoordinate:location];
        annotation.title = tempLocation.name;
        
        if ([tempLocation.type isEqualToString:@"Item"]){
            annotation.icon = @"Item";
        }
        else if ([tempLocation.type isEqualToString:@"Node"]){
            annotation.icon = @"Node";
        }
        else if ([tempLocation.type isEqualToString:@"Npc"]){
            annotation.icon = @"Npc";
        }
        else if ([tempLocation.type isEqualToString:@"WebPage"]){
            annotation.icon = @"WebPage";
        }
        else if ([tempLocation.type isEqualToString:@"AugBubble"]){
            annotation.icon = @"AugBubble";
        }
        else if ([tempLocation.type isEqualToString:@"PlayerNote"]){
            annotation.icon = @"PlayerNote";
        }
        else {
            annotation.icon = @"ERROR";
        }
        
        [annotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:annotations];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createPlayerLocations:) name:@"CreatePlayerLocations" object:nil];
    [[AppServices sharedAppServices] getLocationsOfGamePlayers:[NSString stringWithFormat:@"%i", self.game.gameId]];
}

- (void) createPlayerLocations:(NSNotification *)n{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CreateAnnotations" object:nil];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    AnnotationGameLocation *annotation;
    for(id key in [AppModel sharedAppModel].playersInGame){
        Player *tempPlayer = [[AppModel sharedAppModel].playersInGame objectForKey:key];
        location.latitude = tempPlayer.location.coordinate.latitude;
        location.longitude = tempPlayer.location.coordinate.longitude;
        annotation = [[AnnotationGameLocation alloc] init];
        [annotation setCoordinate:location];
        annotation.title = [NSString stringWithFormat:@"%i", tempPlayer.playerId];
        annotation.icon = @"Player";
        annotation.title = tempPlayer.username;
        [annotations addObject:annotation];
    }
    [self.mapView addAnnotations:annotations];
    [self setMapRegion];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    self.didIFlip = NO;
    
    [self.mapView setMapType:mapType];
    
    //Make the Map
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-88)];//-88 to compensate for the navbar and status bar
    //NOTE: 44+20? NOt guaranteed constant
    
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    [self.view addSubview:self.mapView];
    
    //used to get the actual location
    self.mapView.delegate = self;
    
    
    //Grab the Annotations
    //go grab the location data from the server
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createAnnotations:) name:@"CreateAnnotations" object:nil];
    [[AppServices sharedAppServices] getLocationsForGame:[NSString stringWithFormat:@"%i", self.game.gameId]];
    
    
    //Set up the Switch Button
    [self setUpButtonsInMap];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //save the current region before disappearing
    [AppModel sharedAppModel].region = self.mapView.region;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    [self setUpButtonsInMap];
    
    self.didIFlip = YES;
}

- (CGRect)getScreenFrameForCurrentOrientation {
    return [self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        temp.size.height += 12; // Offset by 12 because status/navbar change when in landscape.
        fullScreenRect = temp;
    }
    
    return fullScreenRect;
}


//Hey look, somebody coded the algorithm I spent an hour or so developing...
-(void)zoomToFitMapAnnotations
{
    if([self.mapView.annotations count] == 0){
        NSLog(@"ZERO");
        return;
    }
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(AnnotationGameLocation* annotation in self.mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude);// * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude);// * 1.1; // Add a little extra space on the sides
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

-(void)setMapRegion{
    if([self.mapView.annotations count] == 0){
        NSLog(@"ZERO");
        return;
    }
    
    NSLog(@"NOT ZERO");
    
    MKCoordinateRegion region;
    
    if(self.shouldZoom){
        [self zoomToFitMapAnnotations];
    }
    else{
        region = [AppModel sharedAppModel].region;
        [self.mapView setRegion:region animated:NO];
    }
    
    
    
}

- (void) swapBetweenMapTypes{
    
    mapType += 1;
    mapType %= 3;
    
    [self.mapView setMapType:mapType];//create the 'street' type of map, called 'map'. Sat is 1, hybrid is 2.
    
    //[self.mapView setMapType:1];
}

- (void) setUpButtonsInMap{
    
    if (self.didIFlip == NO){
        CGRect rec = [self getScreenFrameForCurrentOrientation];
        
        //Set up the centerizer using a custom image.
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(rec.size.width -50, rec.size.height -112, 44, 44)];
        [button setImage:[UIImage imageNamed:@"routeWithBorder.png"] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(zoomToFitMapAnnotations)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        //Set up the mapswapper using a custom image.
        UIButton *buttonSwap = [[UIButton alloc] initWithFrame:CGRectMake(rec.size.width -50, rec.size.height -162, 44, 44)];
        [buttonSwap setImage:[UIImage imageNamed:@"mapWithBorder.png"] forState:UIControlStateNormal];
        [buttonSwap addTarget:self
                       action:@selector(swapBetweenMapTypes)
             forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:buttonSwap];
        
        
        
        
    }
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    /*Does not work with multiple pin icons, since it tries to replace them :'[
     //Will have to give different identifiers for the different image styles zB 'pin'
     //Used for efficiency. If we have a lot of pins, reuse them.
     AnnotationViews *view = (AnnotationViews *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
     if(view == nil){
     view = [[AnnotationViews alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
     }
     */
    
    AnnotationViews *view = [[AnnotationViews alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    //NOTE: Makes resuseidentifier worthless
    
    //This could be bad, having zoomToFitMapAnnotations called more than once. However, I'm not sure how
    //to do it otherwise
    //nice thing is is auto goes to it though.....
    //[self zoomToFitMapAnnotations];
    
    return view;
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //Lets us define a region based on the users location. If we want a defined location, use above code instead.
    
    NSLog(@"didUpdateUserLocation was called");
    
    //NOTE: Get rid of unused code
    
    //Used for centering on device, but this isn't useful yet because you're an editor.
    //    CLLocationCoordinate2D loc = [userLocation coordinate];
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    //    [self.mapView setRegion:region animated:NO];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
