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
    
    FriendManager* manager = [[FriendManager alloc] initWithDelegate:self];
    
//    User* user = [[User alloc] init];
//    user.id = @"3";
//    
//    [manager addFriend:user];
}

- (void)friendManager:(FriendManager *)manager successfullyAddedFriend:(User *)friend {
    NSLog(@"Added friend!");
}

- (void)friendManager:(FriendManager *)manager failedToAddFriendWithError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
