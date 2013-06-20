//
//  GameViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Game.h"

@interface GameViewController : UIViewController

@property (strong, nonatomic) UIViewController* currentChildViewController;

@property (strong, nonatomic) Game *game;

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIBarButtonItem *barButton;

- (void) displayContentController:(UIViewController*)content;


@end
