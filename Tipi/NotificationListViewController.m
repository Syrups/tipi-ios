//
//  RequestListViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NotificationListViewController.h"
#import "AnimationLibrary.h"
#import "Room.h"

@implementation NotificationListViewController {
    NSUInteger lastIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    [manager fetchRoomInvitationsOfUser:CurrentUser];
    
    [self animate];
}

- (IBAction)acceptInvitation:(UIView*)sender {
    UITableViewCell* cell = (UITableViewCell*)sender.superview.superview;
    NSIndexPath* indexPath = [self.requestsTableView indexPathForCell:cell];
    
    lastIndex = indexPath.row;
    
    if (indexPath) {
        Room* room = [self.invitations objectAtIndex:indexPath.row];
        RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
        [manager joinRoom:room];
    }
}

#pragma mark - InvitationFetcher

- (void)userManager:(UserManager *)manager successfullyFetchedInvitations:(NSArray *)invitations {
    self.invitations = invitations;
    NSLog(@"%@", invitations);
    [self.requestsTableView reloadData];
    [self animate];
}

- (void)userManager:(UserManager *)manager failedToFetchInvitationsWithError:(NSError *)error {
    // TODO
}

#pragma mark - RoomJoiner

- (void)roomManager:(RoomManager *)manager successfullyJoinedRoom:(Room *)room {
    [self.invitations removeObjectAtIndex:lastIndex];
    [self.requestsTableView reloadData];
}

- (void)roomManager:(RoomManager *)manager failedToJoinRoomWithError:(NSError *)error {
    // TODO
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationCell"];
    Room* invitation = [self.invitations objectAtIndex:indexPath.row];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%@", invitation.name];
    
    UILabel* from = (UILabel*)[cell.contentView viewWithTag:20];
    from.text = [NSString stringWithFormat:@"%@ vous invite à rejoindre :", invitation.owner.username];
    
    UIButton* accept = (UIButton*)[cell.contentView viewWithTag:30];
    accept.layer.borderColor = kCreateBackgroundColor.CGColor;
    accept.layer.borderWidth = 2;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.invitations.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Animations

- (void)animate {
    [self.requestsTableView.visibleCells enumerateObjectsUsingBlock:^(UITableViewCell* cell, NSUInteger idx, BOOL *stop) {
        
        [AnimationLibrary animateBouncingView:cell withDelay:idx * 0.2f];
        
    }];
    
}

@end
