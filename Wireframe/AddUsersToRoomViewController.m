//
//  AddUsersToRoomViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AddUsersToRoomViewController.h"

@interface AddUsersToRoomViewController ()

@end

@implementation AddUsersToRoomViewController {
    NSMutableArray* selectedFriends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedFriends = [NSMutableArray array];
    self.friends = [NSArray array];
    
    FriendManager* manager = [[FriendManager alloc] initWithDelegate:self];
    [manager fetchFriendsOfUser:CurrentUser];
}

- (IBAction)create:(id)sender {
    if (self.room == nil) { // This is a new room being created
        RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
        [manager createRoomWithName:self.roomName andUsers:selectedFriends];
    } else { // Adding people to existing room
        RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
        NSLog(@"%@", selectedFriends);
        [manager inviteUsers:selectedFriends toRoom:self.room];
    }
    
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

#pragma mark - RoomCreator

- (void)roomManager:(RoomManager *)manager successfullyCreatedRoom:(Room *)room {
    // success
    
    // pop to rooms list
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)roomManager:(RoomManager *)manager failedToCreateRoom:(NSError *)error {
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
    
    NSLog(@"%@", results);
}

- (void)userManager:(UserManager *)manager failedToFindUsersWithError:(NSError *)error {
    ErrorAlert(@"Une erreur est survenue. Merci de réessayer plus tard");
}

#pragma mark - UITextField

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSLog(@"%@", textField.text);
    
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    [manager findUsersWithQuery:[self.searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
