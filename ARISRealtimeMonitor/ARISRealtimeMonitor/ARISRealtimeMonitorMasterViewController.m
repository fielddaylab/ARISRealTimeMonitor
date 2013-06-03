//
//  ARISRealtimeMonitorMasterViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "ARISRealtimeMonitorMasterViewController.h"

#import "ARISRealtimeMonitorDetailViewController.h"

#import "AppModel.h"

#import "AppServices.h"

#import "SimpleTableCell.h"


@implementation ARISRealtimeMonitorMasterViewController

@synthesize gameViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Select a Game";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //get the games list from the server
    [[AppModel sharedAppModel] setGamesList:[[AppServices sharedAppServices] getGamesList]];
    [[AppModel sharedAppModel] setPlayersList:[[AppServices sharedAppServices] getPlayersList]];
    
    //this will need to be moved
    [[AppModel sharedAppModel] setGameEvents:[[NSMutableArray alloc]init]];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [[[AppModel sharedAppModel] gamesList] count];
    }
    else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([indexPath section] == 0){
        static NSString *CellIdentifier = @"SimpleTableItem";
        SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        cell.gameLabel.text = [[[AppModel sharedAppModel] gamesList] objectAtIndex:indexPath.row];
        cell.playersLabel.text = [[[AppServices sharedAppServices] getPlayersList] objectAtIndex:indexPath.row];
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"Logout";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 0){
        NSString *game = [[[AppModel sharedAppModel] gamesList] objectAtIndex:indexPath.row];
        //NSString *game = [[[AppServices instance] getGamesList] objectAtIndex:indexPath.row];
        
        
        self.gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
        self.gameViewController.game = game;
        
        
        //Set the 'GAMES' back button for Map/TableViews here.
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Games" style:UIBarButtonItemStyleBordered target:nil action:nil];
        
        
        if([[[AppModel sharedAppModel] gameEvents] count] <= indexPath.row){
            self.gameViewController.gameAccessNum = [[[AppModel sharedAppModel] gameEvents] count];
            [[[AppModel sharedAppModel] gameEvents] addObject:[[AppServices sharedAppServices] getGameEventsForGame:indexPath.row]];
        }
        else{
            NSMutableArray *eventsToInsert = [[[AppModel sharedAppModel] gameEvents] objectAtIndex:indexPath.row];
            if(![[[AppModel sharedAppModel] gameEvents] containsObject:eventsToInsert]){
                self.gameViewController.gameAccessNum = [[[AppModel sharedAppModel] gameEvents] count];
                [[[AppModel sharedAppModel] gameEvents] addObject:[[AppServices sharedAppServices] getGameEventsForGame:indexPath.row]];
            }
            else{
                self.gameViewController.gameAccessNum = [[[AppModel sharedAppModel] gameEvents] indexOfObject:eventsToInsert];
            }
        }

        
        
        
        [self.navigationController pushViewController:self.gameViewController animated:YES];
        
    }
    else{
        //do some clean up, then quit the app
        exit(0);
    }

}

@end
