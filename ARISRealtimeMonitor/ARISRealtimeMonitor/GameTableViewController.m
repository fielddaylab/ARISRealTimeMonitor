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

//ACTION : INFO
-(NSString *)displayEvent:(Event *)event{
    if([event.eventType isEqualToString:@"VIEW_MAP"]){
        return NSLocalizedString(@"TableViewedMap", nil);        
    }else if([event.eventType isEqualToString:@"PICKUP_ITEM"]){
        NSString *itemName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TablePickupItem", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, itemName];
    }else if([event.eventType isEqualToString:@"DROP_ITEM"]){
        NSString *itemName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableDroppedItem", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, itemName];
    }else if([event.eventType isEqualToString:@"DROP_NOTE"]){
        NSString *noteName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableDroppedNote", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, noteName];
    }else if([event.eventType isEqualToString:@"DESTROY_ITEM"]){
        NSString *itemName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableDestroyedItem", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, itemName];
    }else if([event.eventType isEqualToString:@"VIEW_ITEM"]){
        NSString *itemName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableViewedItem", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, itemName];
    }else if([event.eventType isEqualToString:@"VIEW_NODE"]){
        NSString *nodeName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableViewedNode", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, nodeName];
    }else if([event.eventType isEqualToString:@"VIEW_NPC"]){
        NSString *characterName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableViewedNPC", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, characterName];        
    }else if([event.eventType isEqualToString:@"VIEW_WEBPAGE"]){
        NSString *webpageName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableViewedWebpage", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, webpageName];
    }else if([event.eventType isEqualToString:@"VIEW_AUGBUBBLE"]){
        NSString *augbubbleName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableViewedNode", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, augbubbleName];
    }else if([event.eventType isEqualToString:@"VIEW_QUESTS"]){
        return NSLocalizedString(@"TableViewedQuests", nil);
    }else if([event.eventType isEqualToString:@"VIEW_INVENTORY"]){
        return NSLocalizedString(@"TableViewedInventory", nil);
    }else if([event.eventType isEqualToString:@"ENTER_QRCODE"]){
        return NSLocalizedString(@"TableEnteredQRCode", nil);
    }else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM"]){
        return NSLocalizedString(@"TableUploadMediaItem", nil);
    }else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_IMAGE"]){
        return NSLocalizedString(@"TableUploadMediaImage", nil);
    }else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_AUDIO"]){
        return NSLocalizedString(@"TableUploadMediaAudio", nil);
    }else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_VIDEO"]){
        return NSLocalizedString(@"TableUploadMediaVideo", nil);
    }else if([event.eventType isEqualToString:@"RECEIVE_WEBHOOK"]){
        return NSLocalizedString(@"TableReceivedWebhook", nil);
    }else if([event.eventType isEqualToString:@"SEND_WEBHOOK"]){
        return NSLocalizedString(@"TableSentWebhook", nil);
    }else if([event.eventType isEqualToString:@"COMPLETE_QUEST"]){
        NSString *questName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableQuestCompleted", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, questName];
    }else if([event.eventType isEqualToString:@"GET_NOTE"]){
        NSString *noteName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableReceivedNote", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, noteName];
    }else if([event.eventType isEqualToString:@"GIVE_NOTE_LIKE"]){
        NSString *noteName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableGaveNoteLike", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, noteName];
    }else if([event.eventType isEqualToString:@"GET_NOTE_LIKE"]){
        NSString *noteName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableReceivedNoteLike", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, noteName];
    }else if([event.eventType isEqualToString:@"GIVE_NOTE_COMMENT"]){
        NSString *commentName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableGaveNoteComment", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, commentName];
    }else if([event.eventType isEqualToString:@"GET_NOTE_COMMENT"]){
        NSString *commentName = event.eventDetail1;
        NSString *s = NSLocalizedString(@"TableReceivedNoteComment", nil);
        return [NSString stringWithFormat:@"%@ : \"%@\"", s, commentName];
    }else{
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
