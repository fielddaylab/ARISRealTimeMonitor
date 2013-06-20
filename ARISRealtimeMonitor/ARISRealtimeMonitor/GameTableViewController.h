//
//  GameTableViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameViewController.h"
#import "Game.h"

@interface GameTableViewController : UIViewController//GameViewController

@property (nonatomic, strong) Game *game;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
