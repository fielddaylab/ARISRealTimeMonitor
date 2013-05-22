//
//  LoginViewController.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "LoginViewController.h"
#import "ARISRealtimeMonitorMasterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToGameScreen:(id)sender {
    ARISRealtimeMonitorMasterViewController *masterViewController = [[ARISRealtimeMonitorMasterViewController alloc] initWithNibName:@"ARISRealtimeMonitorMasterViewController_iPhone" bundle:nil];
    NSLog(@"goToGameScreenExecuted");
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
    
@end
