//
//  FriendListViewController.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FriendListViewController.h"
#import "UserSession.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friends = [NSMutableArray array];
    
    FriendManager* manager = [[FriendManager alloc] initWithDelegate:self];
    [manager fetchFriendsOfUser:CurrentUser];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FriendFetcher

- (void)friendManager:(FriendManager *)manager successfullyFetchedFriends:(NSArray *)friends ofUser:(User *)user {
    self.friends = friends.mutableCopy;
    [self.friendsTableView reloadData];
    
    NSLog(@"%@", self.friends);
}

- (void)friendManager:(FriendManager *)manager failedToFetchFriendsOfUser:(User *)user withError:(NSError *)error {
    // ERROR
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    User* friend = [self.friends objectAtIndex:indexPath.row];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = friend.username;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

@end
