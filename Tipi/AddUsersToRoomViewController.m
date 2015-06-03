//
//  AddUsersToRoomViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AddUsersToRoomViewController.h"
#import "TPLoader.h"

@interface AddUsersToRoomViewController ()

@end

@implementation AddUsersToRoomViewController {
    NSMutableArray* selectedFriends;
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedFriends = [NSMutableArray array];
    self.friends = [NSArray array];
}

- (IBAction)validate:(id)sender {
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager inviteUsers:selectedFriends toRoom:self.room];
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FriendFetcher

- (void)friendManager:(FriendManager *)manager successfullyFetchedFriends:(NSArray *)friends ofUser:(User *)user {
    self.friends = friends;
    [self.friendsTableView reloadData];
    
}

- (void)friendManager:(FriendManager *)manager failedToFetchFriendsOfUser:(User *)user withError:(NSError *)error {
    ErrorAlert(@"Une erreur est survenue, merci de réessayer plus tard");
}

#pragma mark - RoomInviter

- (void)roomManager:(RoomManager *)manager successfullyInvitedUsersToRoom:(Room *)room {
    [loader removeFromSuperview];
    
    // pop to room
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)roomManager:(RoomManager *)manager failedToInviteUsersToRoom:(Room *)room withError:(NSError *)error {
    [loader removeFromSuperview];
    ErrorAlert(@"Une erreur est survenue, merci de réessayer plus tard");
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    User* friend = [self.friends objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
    }
    
    NSLog(@"%@", friend.username);
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = friend.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User* friend = [self.friends objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![selectedFriends containsObject:friend.id]) {
        [selectedFriends addObject:friend.id];
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
        label.alpha = 1;
    } else {
        [selectedFriends removeObject:friend.id];
        UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
        label.alpha = .4f;
    }
}

#pragma mark - UserFinder

- (void)userManager:(UserManager *)manager successfullyFindUsers:(NSArray *)results {
    self.friends = results;
    [self.friendsTableView reloadData];
    
    self.activityIndicator.hidden = YES;
}

- (void)userManager:(UserManager *)manager failedToFindUsersWithError:(NSError *)error {
    ErrorAlert(@"Une erreur est survenue. Merci de réessayer plus tard");
    self.activityIndicator.hidden = YES;
}

#pragma mark - UITextField

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    self.activityIndicator.hidden = NO;
    
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    [manager findUsersWithQuery:[self.searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
