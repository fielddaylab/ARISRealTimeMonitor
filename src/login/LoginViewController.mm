//
//  LoginViewController.m
//  ARIS
//
//  Created by Ben Longoria on 2/11/09.
//  Copyright 2009 University of Wisconsin. All rights reserved.
//

#import "LoginViewController.h"

using namespace std; //math.h undef's "isinf", which is used in mapkit...
#import <CoreLocation/CLLocation.h>

#import "AppServices.h"

#import "SelfRegistrationViewController.h"
#import "ChangePasswordViewController.h"
#import "ForgotPasswordViewController.h"
#import "BumpTestViewController.h"

#import "Player.h"
#import "ServiceResult.h"

#import "ARISAlertHandler.h"


@interface LoginViewController() <SelfRegistrationViewControllerDelegate>
{
    IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIButton *loginButton;
    IBOutlet UIButton *qrButton;
	IBOutlet UIButton *newAccountButton;
    IBOutlet UIButton *changePassButton;
    
	IBOutlet UILabel *newAccountMessageLabel;
    
    id<LoginViewControllerDelegate> __unsafe_unretained delegate;
    
    NSString *groupName;
    int gameId;
    BOOL newPlayer;
    BOOL disableLeaveGame;
    
    //For holding on to the player's location before he exists (/ is logged in)
    CLLocation *location;
}

- (IBAction) newAccountButtonTouched:(id)sender;
- (IBAction) loginButtonTouched:(id)sender;
- (IBAction) QRButtonTouched;
- (IBAction) changePassTouch;

@end

@implementation LoginViewController

- (id)initWithDelegate:(id<LoginViewControllerDelegate>)d
{
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
    if(self)
    {
        delegate = d;
        self.title = NSLocalizedString(@"LoginTitleKey", @"");
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLocation:) name:@"PlayerMoved" object:nil];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    usernameField.placeholder = NSLocalizedString(@"UsernameKey", @"");
    passwordField.placeholder = NSLocalizedString(@"PasswordKey", @"");
    [loginButton setTitle:NSLocalizedString(@"LoginKey",@"") forState:UIControlStateNormal];
    newAccountMessageLabel.text = NSLocalizedString(@"NewAccountMessageKey", @"");
    [newAccountButton setTitle:NSLocalizedString(@"CreateAccountKey",@"") forState:UIControlStateNormal];
    
    [self resetState];
}

- (void) resetState
{
    usernameField.text = @"";
    passwordField.text = @"";
    gameId = 0;
    newPlayer = NO;
}

- (void) saveLocation:(NSNotification *)n
{
    location = [n.userInfo objectForKey:@"location"];
}

- (void) resignKeyboard
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void) attemptLogin
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResponseReady:) name:@"LoginResponseReady" object:nil];
    [[AppServices sharedAppServices] loginUserName:usernameField.text password:passwordField.text userInfo:nil];
}

- (void) attemptAutomatedUserCreation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResponseReady:) name:@"LoginResponseReady" object:nil]; //Uses same return info as login
    newPlayer = YES;
    [[AppServices sharedAppServices] createUserAndLoginWithGroup:[NSString stringWithFormat:@"%d-%@", gameId, groupName]];
}

- (void) loginResponseReady:(NSNotification *)n
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginResponseReady" object:nil];
    ServiceResult *r = (ServiceResult *)[n.userInfo objectForKey:@"result"];
    if(!r.data || r.data == [NSNull null])
        [[ARISAlertHandler sharedAlertHandler] showAlertWithTitle:@"Login Unsuccessful" message:@"Username/Password not found"];
    else
    {
        Player *p = [[Player alloc] initWithDictionary:(NSMutableDictionary *)r.data];
        if(location) p.location = location;
        [delegate loginCredentialsApprovedForPlayer:p toGame:gameId newPlayer:newPlayer disableLeaveGame:disableLeaveGame];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == usernameField) { [passwordField becomeFirstResponder]; }
    if(textField == passwordField) { [self resignKeyboard]; [self attemptLogin]; }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignKeyboard];
}

-(IBAction)loginButtonTouched:(id)sender
{
    [self resignKeyboard];
    [self attemptLogin];
}

-(void)changePassTouch
{
    [self resignKeyboard];
    ForgotPasswordViewController *forgotPassViewController = [[ForgotPasswordViewController alloc] init];
    [[self navigationController] pushViewController:forgotPassViewController animated:NO];
}

-(IBAction)newAccountButtonTouched:(id)sender
{
    [self resignKeyboard];
    SelfRegistrationViewController *selfRegistrationViewController = [[SelfRegistrationViewController alloc] initWithDelegate:self];
    [[self navigationController] pushViewController:selfRegistrationViewController animated:NO];
}

- (void) registrationSucceededWithUsername:(NSString *)username password:(NSString *)password
{
    [self resetState];
    usernameField.text = username;
    passwordField.text = password;
    newPlayer = YES;
    [self attemptLogin];
}
@end
