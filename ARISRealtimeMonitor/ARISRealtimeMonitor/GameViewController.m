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
    NSLog(@"Switch Activated");
    //deactivate button to prevent multiple views being created.
    [self.barButton setEnabled:NO];
    
    UIViewController *fromVC = [[self childViewControllers]objectAtIndex:0];
    UIViewController *toVC;
    if([fromVC isKindOfClass:[GameMapViewController class]]){
        toVC = (UIViewController *)[[GameTableViewController alloc] initWithNibName:@"GameTableViewController" bundle:nil];

        // only used if want a border around the button.
        // [self.barButton setImage:[UIImage imageNamed:@"73-radar.png"]];
        
        [self.button setImage:[UIImage imageNamed:@"73-radar.png"] forState:UIControlStateNormal];
        [self.navigationItem setRightBarButtonItem:self.barButton];
    }
    else{
        toVC = (UIViewController *)[[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];
        
        // only used if want a border around the button.
        //[self.barButton setImage:[UIImage imageNamed:@"179-notepad.png"]];
        
        [self.button setImage:[UIImage imageNamed:@"179-notepad.png"] forState:UIControlStateNormal];
        [self.navigationItem setRightBarButtonItem:self.barButton];
    }
    
    
    [self addChildViewController:toVC];
    if([fromVC isKindOfClass:[GameMapViewController class]]){
        GameTableViewController *toVC2 = (GameTableViewController *)toVC;
        toVC2.gameAccessNum = self.gameAccessNum;
        [self transitionFromViewController:fromVC toViewController:toVC2 duration: .5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{} completion:^(BOOL finished){
            [fromVC removeFromParentViewController];
            [toVC2 didMoveToParentViewController:self];
            [self.barButton setEnabled:YES];
        }];
    }
    else{
        [self transitionFromViewController:fromVC toViewController:toVC duration: .5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{} completion:^(BOOL finished){
            [fromVC removeFromParentViewController];
            [toVC didMoveToParentViewController:self];
            //reactivate button
            [self.barButton setEnabled:YES];
        }];
    }

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.game;
    
    //If no border around table/map buttons
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.button setImage:[UIImage imageNamed:@"179-notepad.png"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(flipView) forControlEvents:UIControlEventTouchUpInside];
    self.barButton = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    self.navigationItem.rightBarButtonItem = self.barButton;
    
    /*//If border around table/map buttons
    self.barButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(flipView)];
    [self.barButton setImage:[UIImage imageNamed:@"179-notepad.png"]];
    [self.navigationItem setRightBarButtonItem:self.barButton];
    */
    
    GameMapViewController *gameMapViewController = [[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];

    [self addChildViewController:gameMapViewController];
    [self displayContentController:[[self childViewControllers] objectAtIndex:0]];



    
    //[self.navigationItem setBackBarButtonItem//Can this be used instead?
    //[self.navigationItem setLeftBarButtonItem:@"Games"];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
