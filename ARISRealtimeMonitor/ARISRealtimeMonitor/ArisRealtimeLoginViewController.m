//
//  LoginViewController.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "ArisRealtimeLoginViewController.h"
#import "LostPasswordViewController.h"
#import "LoginTableCell.h"
#import "AppServices.h"
#import "SelectGameViewController.h"
#import "ServiceResult.h"
#import "ARISAlertHandler.h"

@interface ArisRealtimeLoginViewController (){
    UITextField *usernameField;
    UITextField *passwordField;
}

@end

@implementation ArisRealtimeLoginViewController 

@synthesize goToGameSelectOutlet, goToLostPasswordOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"NavBarARTM", nil); 
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutWasRequested) name:@"LogoutRequested" object:nil];
    return self;
}

- (IBAction)goToLostPassword:(id)sender {
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"NavBarToLogin", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    LostPasswordViewController *lostPasswordView = [[LostPasswordViewController alloc] initWithNibName:@"LostPasswordViewController" bundle:nil];
    
    [self.navigationController pushViewController:lostPasswordView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [goToGameSelectOutlet setTitle:NSLocalizedString(@"ButtonToGameSelect", nil) forState:UIControlStateNormal];
    [goToLostPasswordOutlet setTitle:NSLocalizedString(@"ButtonToLostPassword", nil) forState:UIControlStateNormal];
    
    UITapGestureRecognizer *dismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:dismissKB];
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    
    [usernameField setText:@""];
    [passwordField setText:@""];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        tableView.scrollEnabled = NO;
        static NSString *CellIdentifier = @"TextFieldCell";
        LoginTableCell *cell = (LoginTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if(indexPath.row == 0){
            usernameField = cell.textField;
            cell.textField.placeholder = NSLocalizedString(@"TextFieldARTMUsername", nil);
        }
        else{
            passwordField = cell.textField;
            cell.textField.placeholder = NSLocalizedString(@"TextFieldARTMPassword", nil);
            cell.textField.secureTextEntry = YES;
            [cell.textField setReturnKeyType:UIReturnKeyDone];
        }
        
        return cell;
}

- (void)loginSucceed:(ServiceResult *)r
{
    SelectGameViewController *selectGameViewController = [[SelectGameViewController alloc] initWithNibName:@"SelectGameViewController" bundle:nil];
    selectGameViewController.editorId = [r.data valueForKey:@"editor_id"];
    selectGameViewController.editorToken = [r.data valueForKey:@"read_write_token"];
    [self.navigationController pushViewController:selectGameViewController animated:YES];
}

- (void) attemptLogin
{
    [self dismissKeyboard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResponseReady:) name:@"LoginEditorResponseReady" object:nil];
    [[AppServices sharedAppServices] loginEditorUserName:usernameField.text password:passwordField.text userInfo:nil];

}

- (void) loginResponseReady:(NSNotification *)n
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginEditorResponseReady" object:nil];
    
    ServiceResult *r = (ServiceResult *)[n.userInfo objectForKey:@"result"];
    if(!r.data || r.data == [NSNull null])
        [[ARISAlertHandler sharedAlertHandler] showAlertWithTitle:NSLocalizedString(@"ServerARTMLoginUnsuccessful", nil) message:NSLocalizedString(@"ServerARTMBadUsernameAndPass", nil)];

    else
        [self loginSucceed:r];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == usernameField) { [passwordField becomeFirstResponder]; }
    if(textField == passwordField) { [self resignFirstResponder]; [self attemptLogin]; }

    return YES;

}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
- (IBAction)goToGameSelect:(id)sender {
    [self attemptLogin];
}

- (void) logoutWasRequested
{
    [self.navigationController  popToRootViewControllerAnimated:YES];
}


//NOTE: not iOS5 Ready, may be overwritten by navcontroller anyway
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
