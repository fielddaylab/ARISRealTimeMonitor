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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[loginController setTitle:@"Aris Realtime Monitor"];
    }
    return self;
}

- (IBAction)goToLostPassword:(id)sender {
    
    //Set up the back button for the LostPasswordVC
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Login" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    LostPasswordViewController *lostPasswordView = [[LostPasswordViewController alloc] initWithNibName:@"LostPasswordViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:lostPasswordView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Aris Realtime Monitor";
    
    UITapGestureRecognizer *dismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    
    
    [self.view addGestureRecognizer:dismissKB];
}

- (void)viewWillAppear:(BOOL)animated{
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

// Customize the appearance of table view cells.
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
            cell.textField.placeholder = @"Username";
        }
        else{
            passwordField = cell.textField;
            cell.textField.placeholder = @"Password";
            cell.textField.secureTextEntry = YES;
            [cell.textField setReturnKeyType:UIReturnKeyDone];
        }
        
        return cell;
}



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //This means it'll be the login button
//    if([indexPath section] != 0){
//        
//        //grab the username and password from the textfields, verify that they are correct
//        
//        LoginTableCell *loginUsernameCell = (LoginTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        LoginTableCell *loginPasswordCell = (LoginTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//        
//        NSString *username = [[loginUsernameCell textField] text];
//        NSString *password = [[loginPasswordCell textField] text];
//        
//        //[self attemptLoginWithUsername:username andPassword:password];
//        //comparison check between entered info and server check or whatever
//        
//        [self loginSucceed];
//    }
//}


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
    NSLog(@"Login Response YES");
    
    ServiceResult *r = (ServiceResult *)[n.userInfo objectForKey:@"result"];
    if(!r.data || r.data == [NSNull null])
        //make these localized strings
        [[ARISAlertHandler sharedAlertHandler] showAlertWithTitle:@"Login Unsuccessful (make localized)" message:@"Username/Password not found (make localized)"];
    else
    {
        [self loginSucceed:r];
//        Player *p = [[Player alloc] initWithDictionary:(NSMutableDictionary *)r.data];
//        if(location) p.location = location;
//        [delegate loginCredentialsApprovedForPlayer:p toGame:gameId newPlayer:newPlayer disableLeaveGame:disableLeaveGame];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //[textField resignFirstResponder];
    
    //copied and hacked from ARIS
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
@end
