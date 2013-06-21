//
//  SelectGameViewController.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 6/4/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "SelectGameViewController.h"
#import "AppModel.h"
#import "AppServices.h"
#import "Game.h"
#import "JSON.h"

@interface SelectGameViewController ()

@end

@implementation SelectGameViewController

@synthesize gameViewController, selectGameTableView, editorId, editorToken;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"NavBarGameSelect", nil);
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NavBarToLoginFromGameSelect", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction)];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamesListReady:) name:@"GamesListReady" object:nil];
    [[AppServices sharedAppServices] getGamesForEditor:editorId editorToken:editorToken];
}

- (void) gamesListReady:(NSNotification *)n{
    //NOTE: why remove? better not to have single letters
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GamesListReady" object:nil];
    [selectGameTableView reloadData];
}

    
- (void)logoutAction
{ 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppModel sharedAppModel] listOfPlayersGames] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectGameTableView setScrollsToTop:NO];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Game *game = [[[AppModel sharedAppModel] listOfPlayersGames] objectAtIndex:indexPath.row];
    cell.textLabel.text = game.name;
    
    NSString *stringPlayer = NSLocalizedString(@"LabelGameSelectPlayer", nil);
    NSString *stringPlayers = NSLocalizedString(@"LabelGameSelectPlayers", nil);
    cell.detailTextLabel.text = (game.numPlayers == 1)? [NSString stringWithFormat:@"%@: %i", stringPlayer, game.numPlayers]: [NSString stringWithFormat:@"%@: %i", stringPlayers, game.numPlayers];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row%2)?[UIColor colorWithRed:210.0/255.0 green:214.0/255.0 blue:217.0/255.0 alpha:1.0]:[UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    Game *game = [[[AppModel sharedAppModel] listOfPlayersGames] objectAtIndex:indexPath.row];
    
    self.gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    self.gameViewController.game = game;
    
    //Set the 'GAMES' back button for Map/TableViews here.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NavBarToGameSelect", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self.navigationController pushViewController:self.gameViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end