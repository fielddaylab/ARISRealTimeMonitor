//
//  GameViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "Game.h"

@interface GameViewController : UIViewController

@property (strong, nonatomic) UIViewController* currentChildViewController;

@property (strong, nonatomic) Game *game;

@property (strong, nonatomic) UIButton *withoutBorderButton;
@property (strong, nonatomic) UIBarButtonItem *rightNavBarButton;

- (void) displayContentController:(UIViewController*)content;


@end
