//
//  AddFriendViewController.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AddFriendViewController.h"

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendManager = [[FriendManager alloc] initWithDelegate:self];

    if ([self.searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
    
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    [manager findUsersWithQuery:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UserFinder

- (void)userManager:(UserManager *)manager successfullyFindUsers:(NSArray *)results {
    self.friends = results;
    [self.resultsTableView reloadData];
}

- (void)userManager:(UserManager *)manager failedToFindUsersWithError:(NSError *)error {
    // ERROR
    NSLog(@"%@", error);
}

#pragma mark - FriendAdder

- (void)friendManager:(FriendManager *)manager successfullyAddedFriend:(User *)friend {
    NSLog(@"Added friend!");
}

- (void)friendManager:(FriendManager *)manager failedToAddFriendWithError:(NSError *)error {
    NSLog(@"%@", error);
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

@end
