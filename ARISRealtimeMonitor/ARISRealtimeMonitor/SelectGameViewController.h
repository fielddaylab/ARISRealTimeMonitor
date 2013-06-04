//
//  SelectGameViewController.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 6/4/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface SelectGameViewController : UIViewController
- (IBAction)logoutAction:(id)sender;

@property (nonatomic, strong) GameViewController *gameViewController;

@end
