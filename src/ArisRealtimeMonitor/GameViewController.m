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


@implementation GameViewController

@synthesize game;

@synthesize currentChildViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Game";
    }
    return self;
}


-(IBAction)flipView{
    
    //figure out which view to flip to
    [self.barButton setEnabled:NO];
    UIViewController *fromVC = [self currentChildViewController];
    GameMapViewController *toVCMap;
    GameTableViewController *toVCTable;
    UIViewController *toVC;
    NSUInteger animation;
    if([fromVC isKindOfClass:[GameMapViewController class]]){
        
        toVCTable = [[GameTableViewController alloc] initWithNibName:@"GameTableViewController" bundle:nil];
        animation = UIViewAnimationOptionTransitionFlipFromRight;
        [self.button setImage:[UIImage imageNamed:@"73-radar.png"] forState:UIControlStateNormal];
        toVC = toVCTable;
    }
    else{
        
        toVCMap = [[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];
        toVCMap.game = self.game;
        animation = UIViewAnimationOptionTransitionFlipFromLeft;
        [self.button setImage:[UIImage imageNamed:@"179-notepad.png"] forState:UIControlStateNormal];
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
        [self.barButton setEnabled:YES];
    }];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.game.name;

    //Set up the right navbar buttons without a border.
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.button setImage:[UIImage imageNamed:@"179-notepad.png"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(flipView) forControlEvents:UIControlEventTouchUpInside];
    self.barButton = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    self.navigationItem.rightBarButtonItem = self.barButton;
    
    GameMapViewController *gameMapViewController = [[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];
    gameMapViewController.game = self.game;

    [self addChildViewController:gameMapViewController];
    [self displayContentController:[[self childViewControllers] objectAtIndex:0]];
}

//stolen and will need to be made more general again
- (void) displayContentController:(UIViewController*)content
{
    if(currentChildViewController) [self hideContentController:currentChildViewController];
    
    [self addChildViewController:content];
    
    //Make a new rectangle with 88 as offset so that the Map is formated in the correct spot
    //content.view.frame = CGRectMake(0, 88, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-88);
    
    content.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)+88);
    
    //Used to use this, but doesn't work well with nav/status bars and maps.
    //[self screenRect];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
