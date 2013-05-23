//
//  GameViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)flipView{
    NSLog(@"Switch Activated");
    
    UIViewController *fromVC = [[self childViewControllers]objectAtIndex:0];
    UIViewController *toVC;
    if([fromVC isKindOfClass:[GameMapViewController class]]){
        NSLog(@"You are in table view");
        toVC = (UIViewController *)[[GameTableViewController alloc] initWithNibName:@"GameTableViewController" bundle:nil];
    }
    else{
        NSLog(@"You are in map view");
        toVC = (UIViewController *)[[GameMapViewController alloc] initWithNibName:@"GameMapViewController" bundle:nil];
    }
    
    
    
    [self addChildViewController:toVC];
    [self transitionFromViewController:fromVC toViewController:toVC duration: .5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{} completion:^(BOOL finished){
        [fromVC removeFromParentViewController];
        [toVC didMoveToParentViewController:self];
    }];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //- (id)initWithImage:(UIImage *)image style:UIBarButtonItemStylePlain target:self action:@selector(flipView)

    UIBarButtonItem *switchButton = [[UIBarButtonItem alloc] initWithTitle:@"Switch" style:UIBarButtonItemStylePlain target:self action:@selector(flipView)];
    self.navigationItem.rightBarButtonItem = switchButton;
    
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
