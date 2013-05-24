//
//  GameViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController

@synthesize game;


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
    
    [self.barButton setEnabled:NO];
    
    UIViewController *fromVC = [[self childViewControllers]objectAtIndex:0];
    UIViewController *toVC;
    if([fromVC isKindOfClass:[GameMapViewController class]]){
        toVC = (UIViewController *)[[GameTableViewController alloc] initWithNibName:@"GameTableViewController" bundle:nil];
        
        [self.barButton setImage:[UIImage imageNamed:@"179-notepad.png"]];
        [self.navigationItem setRightBarButtonItem:self.barButton];
    }
    else{
        toVC = (UIViewController *)[[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];
        
        [self.barButton setImage:[UIImage imageNamed:@"73-radar.png"]];
        [self.navigationItem setRightBarButtonItem:self.barButton];
    }
    
    
    [self addChildViewController:toVC];
    if([fromVC isKindOfClass:[GameMapViewController class]]){
        [self transitionFromViewController:fromVC toViewController:toVC duration: .5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{} completion:^(BOOL finished){
            [fromVC removeFromParentViewController];
            [toVC didMoveToParentViewController:self];
            [self.barButton setEnabled:YES];
        }];
    }
    else{
        [self transitionFromViewController:fromVC toViewController:toVC duration: .5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{} completion:^(BOOL finished){
            [fromVC removeFromParentViewController];
            [toVC didMoveToParentViewController:self];
            [self.barButton setEnabled:YES];
        }];
    }

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Attempts at only having an image, not overlayed on a button.
    //UIImage * mapImage = [[UIImage alloc]initWithContentsOfFile:@"73-radar.png"];    
    //- (id)initWithImage:(UIImage *)image style:UIBarButtonItemStylePlain target:self action:@selector(flipView)
    //UIBarButtonItem *switchButton = [[UIBarButtonItem alloc] initWithImage:mapImage style:UIBarButtonItemStylePlain target:self action:@selector(flipView)];
    
    //This button will have to change depending on user action. Keep World there for now to test button styles.
    self.barButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(flipView)];
    [self.barButton setImage:[UIImage imageNamed:@"73-radar.png"]];
    [self.navigationItem setRightBarButtonItem:self.barButton];
    
    
    
    GameMapViewController *gameMapViewController = [[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];

    [self addChildViewController:gameMapViewController];
    [self displayContentController:[[self childViewControllers] objectAtIndex:0]];

    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
