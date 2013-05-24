//
//  GameViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ARISContainerViewController.h"

#import "GameMapViewController.h"

#import "GameTableViewController.h"

@interface GameViewController : ARISContainerViewController //If ARISContainerVC is a UIVC, is still valid?

@property (strong, nonatomic) NSString  *game;
@property (nonatomic) NSInteger gameNum;
@property (strong, nonatomic) UIBarButtonItem* barButton;


@end
