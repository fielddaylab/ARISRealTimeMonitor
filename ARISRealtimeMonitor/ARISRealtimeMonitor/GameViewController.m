//
//  GameViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController

@synthesize game, gameAccessNum;


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
    UIViewController *toVC;
    NSUInteger animation;
    if([fromVC isKindOfClass:[GameMapViewController class]]){
        toVC = [[GameTableViewController alloc] initWithNibName:@"GameTableViewController" bundle:nil];
        animation = UIViewAnimationOptionTransitionFlipFromRight;
        [self.barButton setImage:[UIImage imageNamed:@"73-radar.png"]];
    }
    else{
        toVC = [[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];
        animation = UIViewAnimationOptionTransitionFlipFromLeft;
        [self.barButton setImage:[UIImage imageNamed:@"179-notepad.png"]];
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
    
    self.title = self.game;
    
    //setup bar button
    self.barButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(flipView)];
    [self.barButton setImage:[UIImage imageNamed:@"179-notepad.png"]];
    [self.navigationItem setRightBarButtonItem:self.barButton];

    
    GameMapViewController *gameMapViewController = [[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];

    [self addChildViewController:gameMapViewController];
    [self displayContentController:[[self childViewControllers] objectAtIndex:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
