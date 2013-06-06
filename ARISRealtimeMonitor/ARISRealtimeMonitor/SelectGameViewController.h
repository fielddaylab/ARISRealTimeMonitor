//
//  SelectGameViewController.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 6/4/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

#import "LoginViewController.h"

@interface SelectGameViewController : UIViewController

@property (nonatomic, strong) GameViewController *gameViewController;

@property (weak, nonatomic) IBOutlet UITableView *selectGameTableView;

@end
