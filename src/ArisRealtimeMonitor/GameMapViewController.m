//
//  GameMapViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameMapViewController.h"
#import <MapKit/MapKit.h>
#import "AnnotationGameLocation.h"
#import "AnnotationViews.h"
#import "AppServices.h"
#import "AppModel.h"
#import "Game.h"
#import "Location.h"
#import "Player.h"

#define MLI_LATITUDE 43.074789;
#define MLI_LONGITUDE -89.408197;

#define HOME_LATITUDE 43.068182;
#define HOME_LONGITUDE -89.406033;

#define CS_LATITUDE 43.071545;
#define CS_LONGITUDE -89.406685;

#define TERRACE_LATITUDE 43.076894;
#define TERRACE_LONGITUDE -89.399711;

#define USOUTH_LATITUDE 43.071976;
#define USOUTH_LONGITUDE -89.408433;

#define SPAN_VALUE .01f;//Lowest you can go seems to be 0.001f; in code.


@interface GameMapViewController ()
@end

@implementation GameMapViewController
@synthesize mapView = _mapView;
@synthesize game;

@synthesize didIFlip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) createAnnotations:(NSNotification *)n{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CreateAnnotations" object:nil];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    AnnotationGameLocation *annotation;
    
    //create locations
    //reads in locations correctly, the title and subtitle of the annotation need to be updated
    
    //location has type associated with it. Can be everything except player (maybe)
    
    for(id key in [AppModel sharedAppModel].locations){
        Location *tempLocation = [[AppModel sharedAppModel].locations objectForKey:key];
        location.latitude = tempLocation.latlon.coordinate.latitude;
        location.longitude = tempLocation.latlon.coordinate.longitude;
        annotation = [[AnnotationGameLocation alloc] init];
        [annotation setCoordinate:location];
        annotation.title = tempLocation.name;
        annotation.subtitle = tempLocation.subtitle; //i dont think this does anything currently
        //add left icon later
        annotation.leftIcon = @"Left Icon Here";
        //add icon later
        annotation.icon = @"Icon Here";
        [annotations addObject:annotation];
    }
    
    //more efficient to add all at once
//    location.latitude = MLI_LATITUDE;
//    location.longitude = MLI_LONGITUDE;
//    annotation = [[AnnotationGameLocation alloc] init];
//    [annotation setCoordinate:location];
//    annotation.title = @"QUEST1 MLI";
//    annotation.subtitle = @"GOAL1 MLI";
//    annotation.leftIcon = @"test1";
//    annotation.icon = @"player";
//    [annotations addObject:annotation];
//    
//    location.latitude = HOME_LATITUDE;
//    location.longitude = HOME_LONGITUDE;
//    annotation = [[AnnotationGameLocation alloc] init];
//    [annotation setCoordinate:location];
//    annotation.title = @"QUEST2 HOME";
//    annotation.subtitle = @"GOAL2 HOME";
//    annotation.leftIcon = @"test1";
//    annotation.icon = @"gameLocation";
//    [annotations addObject:annotation];
//    
//    location.latitude = CS_LATITUDE;
//    location.longitude = CS_LONGITUDE;
//    annotation = [[AnnotationGameLocation alloc] init];
//    [annotation setCoordinate:location];
//    annotation.title = @"QUEST3 CS";
//    annotation.subtitle = @"GOAL3 CS";
//    annotation.leftIcon = @"test1";
//    annotation.icon = @"player";
//    [annotations addObject:annotation];
//    
//    location.latitude = TERRACE_LATITUDE;
//    location.longitude = TERRACE_LONGITUDE;
//    annotation = [[AnnotationGameLocation alloc] init];
//    [annotation setCoordinate:location];
//    annotation.title = @"QUEST4 TERRACE";
//    annotation.subtitle = @"GOAL4 TERRACE";
//    annotation.leftIcon = @"test2";
//    annotation.icon = @"player";
//    [annotations addObject:annotation];
//    
//    location.latitude = USOUTH_LATITUDE;
//    location.longitude = USOUTH_LONGITUDE;
//    annotation = [[AnnotationGameLocation alloc] init];
//    [annotation setCoordinate:location];
//    annotation.title = @"QUEST5 USOUTH";
//    annotation.subtitle = @"GOAL5 USOUTH";
//    annotation.leftIcon = @"test2";
//    annotation.icon = @"notplayer";
//    [annotations addObject:annotation];
    
    [self.mapView addAnnotations:annotations];
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
        //annotation.subtitle = tempLocation.subtitle;
        //add left icon later
        annotation.leftIcon = @"Left Icon Here";
        //add icon later
        annotation.icon = @"player";
        [annotations addObject:annotation];
    }
    [self.mapView addAnnotations:annotations];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    self.didIFlip = NO;
    
    //Make the Map
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-88)];//-88 to compensate for the navbar and status bar
    
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.mapView setMapType:0];//create the 'street' type of map, called 'map'. Sat is 1, hybrid is 2.
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    [self.view addSubview:self.mapView];
    
    //used to get the actual location
    self.mapView.delegate = self;
    
   
    //Grab the Annotations
    //go grab the location data from the server
    //assume first game is click on always
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createAnnotations:) name:@"CreateAnnotations" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createPlayerLocations:) name:@"CreatePlayerLocations" object:nil];
    [[AppServices sharedAppServices] getLocationsForGame:[NSString stringWithFormat:@"%i", self.game.gameId]];
    [[AppServices sharedAppServices] getLocationsOfGamePlayers:[NSString stringWithFormat:@"%i", self.game.gameId]];

    
    //Set up the Switch Button
     [self setUpButtonsInMap];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    NSLog(@"NOT ZERO");
    
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


- (void) setUpButtonsInMap{
    
    if (self.didIFlip == NO){
    CGRect rec = [self getScreenFrameForCurrentOrientation];
    
    //Set up the centerizer using a custom image.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(rec.size.width -50, rec.size.height -112, 44, 44)];
    [button setImage:[UIImage imageNamed:@"246-route.png"] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(zoomToFitMapAnnotations) 
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    }
    //Don't zoom on rotate, because that could cause confusion to the user.
    //[self zoomToFitAnnotations];

//     If want to use a default button for the centerizer
//     UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//     [button addTarget:self
//     action:nil//@selector(aMethod:)
//     forControlEvents:UIControlEventTouchUpInside];
//     [button setTitle:@"Swap" forState:UIControlStateNormal];
//
//     //Try to have off by 6 from border. 44-6 for width; 44navbar, 44button, 18? status bar, 6 for offset.
//     button.frame = CGRectMake(rec.size.width - 50, rec.size.height - (44+44+24),44.0, 44.0);
//    
//     [self.view addSubview:button];
    
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
    
    //This could be bad, having zoomToFitMapAnnotations called more than once. However, I'm not sure how
        //to do it otherwise
    //nice thing is is auto goes to it though.....
    //[self zoomToFitMapAnnotations];
    
    return view;
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //Lets us define a region based on the users location. If we want a defined location, use above code instead.

    NSLog(@"didUpdateUserLocation was called");

    
    //Used for centering on device, but this isn't useful yet because you're an editor.
//    CLLocationCoordinate2D loc = [userLocation coordinate];
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
//    [self.mapView setRegion:region animated:NO];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
