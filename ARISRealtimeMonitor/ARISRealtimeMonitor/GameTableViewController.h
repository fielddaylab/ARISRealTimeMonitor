//
//  GameTableViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameViewController.h"

@interface GameTableViewController : UIViewController//GameViewController

@property (nonatomic) NSInteger gameNum;

- (IBAction)addEntry:(id)sender;

@end
