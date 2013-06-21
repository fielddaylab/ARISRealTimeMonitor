//
//  LoginViewController.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

@interface ArisRealtimeLoginViewController : UIViewController

- (IBAction)goToGameSelect:(id)sender;
- (IBAction)goToLostPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goToGameSelectOutlet;
@property (weak, nonatomic) IBOutlet UIButton *goToLostPasswordOutlet;

@end
