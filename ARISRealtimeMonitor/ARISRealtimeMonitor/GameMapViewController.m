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


- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.didIFlip = NO;
    
    [self.mapView setMapType:mapType];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-88)];//-88 to compensate for the navbar and status bar and still keep 'legal'
    
    self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    
    [self.view addSubview:self.mapView];
    
    self.mapView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createAnnotations:) name:@"CreateAnnotations" object:nil];
    [[AppServices sharedAppServices] getLocationsForGame:[NSString stringWithFormat:@"%i", self.game.gameId]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createPlayerLocations:) name:@"CreatePlayerLocations" object:nil];
    [[AppServices sharedAppServices] getLocationsOfGamePlayers:[NSString stringWithFormat:@"%i", self.game.gameId]];
    
    [self setUpButtonsInMap];
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [AppModel sharedAppModel].region = self.mapView.region;
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CreateAnnotations" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CreatePlayerLocations" object:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    [self setUpButtonsInMap];
    
    self.didIFlip = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) createAnnotations:(NSNotification *)n{
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
}

- (void) createPlayerLocations:(NSNotification *)n{
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

#pragma map delegate functions

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

     AnnotationViews *view = (AnnotationViews *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if(view == nil){
     view = [[AnnotationViews alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
     }
    AnnotationGameLocation *castedAnnotation = ((AnnotationGameLocation *) annotation);

        if ([castedAnnotation.icon isEqualToString:@"Player"]) {
            view.image = [UIImage imageNamed:@"145-persondot.png"];
        }
        else if ([castedAnnotation.icon isEqualToString:@"Item"]){
            view.image = [UIImage imageNamed:@"257-box3.png"];
        }
        else if ([castedAnnotation.icon isEqualToString:@"Node"]){
            view.image = [UIImage imageNamed:@"55-network.png"];
        }
        else if ([castedAnnotation.icon isEqualToString:@"Npc"]){
            view.image = [UIImage imageNamed:@"111-user.png"];
        }
        else if ([castedAnnotation.icon isEqualToString:@"WebPage"]){
            view.image = [UIImage imageNamed:@"174-imac.png"];
        }
        else if ([castedAnnotation.icon isEqualToString:@"AugBubble"]){
            view.image = [UIImage imageNamed:@"08-chat.png"];
        }
        else if ([castedAnnotation.icon isEqualToString:@"PlayerNote"]){
            view.image = [UIImage imageNamed:@"notebook.png"];
        }
        else{
            view.image = [UIImage imageNamed:@"196-radiation.png"];
        }
    
    return view;
}

-(void)zoomToFitMapAnnotations
{
    if([self.mapView.annotations count] == 0){
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
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2;
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

-(void)setMapRegion{
    
    if([self.mapView.annotations count] == 0){
        return;
    }
    
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
    
    [self.mapView setMapType:mapType];
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

@end