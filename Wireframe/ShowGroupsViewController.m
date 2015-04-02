//
//  ShowGroupsViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowGroupsViewController.h"
#import "ShowOneGroupViewController.h"
#import "UserSession.h"
#import "SWRevealViewController.h"
#import "RoomRevealWrapperViewController.h"

@implementation ShowGroupsViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager fetchRoomsForUser:[[UserSession sharedSession] user]];
}

#pragma mark - RoomFetcher

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    self.mGroups = rooms;
    
    [self.mTableView reloadData];
}

- (void)roomManager:(RoomManager *)manager failedToFetchRooms:(NSError*)error{
    // error
}

#pragma mark - UITableView

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Room* room = [self.mGroups objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"groupCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIView* v1 = [cell.contentView viewWithTag:10];
    v1.layer.borderWidth = 1;
    v1.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIView* v2 = [cell.contentView viewWithTag:15];
    v2.layer.borderWidth = 1;
    v2.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:100];
    name.text = room.name;
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mGroups.count;
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToGroupSegue"]) {
        
        NSIndexPath *indexPath = [self.mTableView indexPathForSelectedRow];
        Room* room = [self.mGroups objectAtIndex:indexPath.row];
        NSUInteger selectedRoom = [room.id integerValue];
        
        RoomRevealWrapperViewController* reveal = segue.destinationViewController;
        reveal.roomId = selectedRoom;
    }
}


@end
