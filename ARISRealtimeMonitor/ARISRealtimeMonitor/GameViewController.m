//
//  GameViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameViewController.h"
#import "GameMapViewController.h"
#import "GameTableViewController.h"
#import "JSON.h"
#import "AppServices.h"
#import "AppModel.h"


@implementation GameViewController

@synthesize game;
@synthesize currentChildViewController;

//Note:Could flip button

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Game";
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AppModel sharedAppModel] setEvents:[[NSMutableArray alloc] init]];
    self.title = self.game.name;

    //Set up the right navbar buttons without a border.
    self.withoutBorderButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.withoutBorderButton setImage:[UIImage imageNamed:@"179-notepad.png"] forState:UIControlStateNormal];
    [self.withoutBorderButton addTarget:self action:@selector(flipView) forControlEvents:UIControlEventTouchUpInside];
    self.rightNavBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.withoutBorderButton];
    self.navigationItem.rightBarButtonItem = self.rightNavBarButton;
    
    GameMapViewController *gameMapViewController = [[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];
    gameMapViewController.game = self.game;
    gameMapViewController.shouldZoom = YES;

    [self addChildViewController:gameMapViewController];
    [self displayContentController:[[self childViewControllers] objectAtIndex:0]];
}

- (void) displayContentController:(UIViewController*)content
{
    if(currentChildViewController) [self hideContentController:currentChildViewController];
    
    [self addChildViewController:content];
    
    //Make a new rectangle with 88 as offset so that the Map is formated in the correct spot
    content.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)+88);
    
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
    
    currentChildViewController = content;
}

- (void) hideContentController:(UIViewController*)content
{
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
    
    currentChildViewController = nil;
}

-(IBAction)flipView{
    //figure out which view to flip to
    [self.rightNavBarButton setEnabled:NO];
    UIViewController *fromVC = [self currentChildViewController];
    GameMapViewController *toVCMap;
    GameTableViewController *toVCTable;
    UIViewController *toVC;
    NSUInteger animation;
    if([fromVC isKindOfClass:[GameMapViewController class]]){
        toVCTable = [[GameTableViewController alloc] initWithNibName:@"GameTableViewController" bundle:nil];
        toVCTable.game = self.game;
        animation = UIViewAnimationOptionTransitionFlipFromRight;
        [self.withoutBorderButton setImage:[UIImage imageNamed:@"73-radar.png"] forState:UIControlStateNormal];
        toVC = toVCTable;
    }
    else{
        
        toVCMap = [[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];
        toVCMap.game = self.game;
        toVCMap.shouldZoom = NO;
        animation = UIViewAnimationOptionTransitionFlipFromLeft;
        [self.withoutBorderButton setImage:[UIImage imageNamed:@"179-notepad.png"] forState:UIControlStateNormal];
        toVC = toVCMap;
    }
    
    CGRect rect = fromVC.view.bounds;
    toVC.view.frame = rect;
    
    //transition between views
    [self addChildViewController:toVC];
    [self transitionFromViewController:fromVC toViewController:toVC duration: .5 options:animation animations:^{} completion:^(BOOL finished){
        //hide old view
        [fromVC willMoveToParentViewController:nil];
        [fromVC.view removeFromSuperview];
        [fromVC removeFromParentViewController];
        
        //show new view
        [self.view addSubview:toVC.view];
        [toVC didMoveToParentViewController:self];
        
        currentChildViewController = toVC;
        [self.rightNavBarButton setEnabled:YES];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end