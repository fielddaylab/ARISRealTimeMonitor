//
//  GameTableViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameTableViewController.h"

#import "AppModel.h"
#import "AppServices.h"
#import "Event.h"

#define REFRESH_INTERVAL ((int) 3) //in seconds
#define FIVE_MINUTES ((int) 300) //in seconds

@interface GameTableViewController ()

@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation GameTableViewController

@synthesize game;
@synthesize table;
@synthesize myTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) eventsReady:(NSNotification *)n{
    //NSLog(@"Events Ready");
    NSLog(@"Size of events: %i", [[[AppModel sharedAppModel] events] count]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EventsReady" object:nil];
    [self.table reloadData];
}

-(void)updateEvents{
    NSLog(@"Update events");
//    [[AppModel sharedAppModel] setEvents:[[NSMutableArray alloc] init]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsReady:) name:@"EventsReady" object:nil];
   [[AppServices sharedAppServices] getLogsForGame:[NSString stringWithFormat:@"%i", self.game.gameId] seconds:[NSString stringWithFormat:@"%i", REFRESH_INTERVAL]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [myTimer invalidate];
    myTimer = nil;
    [AppModel sharedAppModel].events = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.table.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsReady:) name:@"EventsReady" object:nil];
    //get the events for the past 5 minutes
    [[AppServices sharedAppServices] getLogsForGame:[NSString stringWithFormat:@"%i", game.gameId] seconds:[NSString stringWithFormat:@"%i", FIVE_MINUTES]];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_INTERVAL
                                               target:self
                                             selector:@selector(updateEvents)
                                             userInfo:nil
                                              repeats:YES];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppModel sharedAppModel] events] count];
    //return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.table setScrollsToTop:NO];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Event *tempEvent = [[[AppModel sharedAppModel] events] objectAtIndex:indexPath.row];
    cell.textLabel.text = [self displayPlayer:tempEvent];
    cell.detailTextLabel.text = [self displayEvent:tempEvent];
    return cell;
}

-(NSString *)displayPlayer:(Event *)event{
        return [NSString stringWithFormat:@"%@", event.username];
}

-(NSString *)displayEvent:(Event *)event{
    
    //change these to localized strings
    if([event.eventType isEqualToString:@"VIEW_MAP"]){
        return [NSString stringWithFormat:@"Viewed the map"];
    }
    else if([event.eventType isEqualToString:@"PICKUP_ITEM"]){
        return [NSString stringWithFormat:@"Picked up an item"];
    }
    else if([event.eventType isEqualToString:@"DROP_ITEM"]){
        return [NSString stringWithFormat:@"Dropped an item"];
    }
    else if([event.eventType isEqualToString:@"DROP_NOTE"]){
        return [NSString stringWithFormat:@"Dropped a note"];
    }
    else if([event.eventType isEqualToString:@"DESTROY_ITEM"]){
        return [NSString stringWithFormat:@"Destroyed an item"];
    }
    else if([event.eventType isEqualToString:@"VIEW_ITEM"]){
        return [NSString stringWithFormat:@"Viewed an item"];
    }
    else if([event.eventType isEqualToString:@"VIEW_NODE"]){
        return [NSString stringWithFormat:@"Viewed a node"];
    }
    else if([event.eventType isEqualToString:@"VIEW_NPC"]){
        return [NSString stringWithFormat:@"Viewed a character"];
    }
    else if([event.eventType isEqualToString:@"VIEW_WEBPAGE"]){
        return [NSString stringWithFormat:@"Viewed a webpage"];
    }
    else if([event.eventType isEqualToString:@"VIEW_AUGBUBBLE"]){
        return [NSString stringWithFormat:@"Viewed an augbubble"];
    }
    else if([event.eventType isEqualToString:@"VIEW_QUESTS"]){
        return [NSString stringWithFormat:@"Viewed their quests"];
    }
    else if([event.eventType isEqualToString:@"VIEW_INVENTORY"]){
        return [NSString stringWithFormat:@"Viewed their inventory"];
    }
    else if([event.eventType isEqualToString:@"ENTER_QRCODE"]){
        return [NSString stringWithFormat:@"Entered a qrcode"];
    }
    else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM"]){
        return [NSString stringWithFormat:@"Uploaded media"];
    }
    else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_IMAGE"]){
        return [NSString stringWithFormat:@"Uploaded an image"];
    }
    else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_AUDIO"]){
        return [NSString stringWithFormat:@"Uploaded an audio clip"];
    }
    else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_VIDEO"]){
        return [NSString stringWithFormat:@"Uploaded an video clip"];
    }
    else if([event.eventType isEqualToString:@"RECEIVE_WEBHOOK"]){
        return [NSString stringWithFormat:@"Received a webhook"];
    }
    else if([event.eventType isEqualToString:@"SEND_WEBHOOK"]){
        return [NSString stringWithFormat:@"Sent a webhook"];
    }
    else if([event.eventType isEqualToString:@"COMPLETE_QUEST"]){
        return [NSString stringWithFormat:@"Completed a quest"];
    }
    else if([event.eventType isEqualToString:@"GET_NOTE"]){
        return [NSString stringWithFormat:@"Got a note"];
    }
    else if([event.eventType isEqualToString:@"GIVE_NOTE_LIKE"]){
        return [NSString stringWithFormat:@"Liked a note"];
    }
    else if([event.eventType isEqualToString:@"GET_NOTE_LIKE"]){
        return [NSString stringWithFormat:@"Received a like on their note"];
    }
    else if([event.eventType isEqualToString:@"GIVE_NOTE_COMMENT"]){
        return [NSString stringWithFormat:@"Commented on a note"];
    }
    else if([event.eventType isEqualToString:@"GET_NOTE_COMMENT"]){
        return [NSString stringWithFormat:@"Received a comment on their note"];
    }
    else{
        return event.eventType;
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do something when a cell is pressed
}


//this can be deleted
- (IBAction)addEntry:(id)sender {
    
    //[self.table reloadData];
}
@end
