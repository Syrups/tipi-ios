//
//  FriendListViewController.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FriendListViewController.h"
#import "UserSession.h"
#import "AnimationLibrary.h"
#import "TPLoader.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController {
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friends = [NSMutableArray array];
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
    
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
    [self animate];
    
    [loader removeFromSuperview];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Animations

- (void)animate {
    [self.friendsTableView.visibleCells enumerateObjectsUsingBlock:^(UITableViewCell* cell, NSUInteger idx, BOOL *stop) {
        
        [AnimationLibrary animateBouncingView:cell];
        
    }];
    
}


@end
