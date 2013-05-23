//
//  ARISRealtimeMonitorDetailViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//


//HOW DO I MAKE A CONTAINER CONTROLLER?!#E@#@$QRESDG
//Copying/Editing code from https://github.com/toolmanGitHub/stackedViewControllers



#import <UIKit/UIKit.h>

#import "GameMapViewController.h"

#import "GameTableViewController.h"


@class GameMapViewController, GameTableViewController;

@interface ARISRealtimeMonitorDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) GameMapViewController *gameMapViewController;

@property (strong, nonatomic) GameTableViewController *gameTableViewController;





@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;


//- (void) displayContentController: (UIViewController*) content;

//- (void) cycleFromViewController: (UIViewController*) oldC toViewController: (UIViewController*) newC;


@end
