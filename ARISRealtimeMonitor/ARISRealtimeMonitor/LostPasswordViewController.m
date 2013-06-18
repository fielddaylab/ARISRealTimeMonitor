//
//  LostPasswordViewController.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/28/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "LostPasswordViewController.h"
#import "AppServices.h"


@interface LostPasswordViewController ()

@end

@implementation LostPasswordViewController

@synthesize emailOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"NavBarLostPassword", nil);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    emailOutlet.placeholder = NSLocalizedString(@"TextFieldLostPasswordEmail", nil);

    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *dismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:dismissKB];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"%@", [textField text]);
    
    [textField resignFirstResponder];
    [[AppServices sharedAppServices] resetAndEmailNewPassword:textField.text];
    return YES;
    
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
