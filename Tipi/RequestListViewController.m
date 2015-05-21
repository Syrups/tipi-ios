//
//  RequestListViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RequestListViewController.h"
#import "AnimationLibrary.h"

@interface RequestListViewController ()

@end

@implementation RequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self animate];
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
//    User* friend = [self.friends objectAtIndex:indexPath.row];
//    
//    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
//    label.text = friend.username;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.requests.count;
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Animations

- (void)animate {
    [self.requestsTableView.visibleCells enumerateObjectsUsingBlock:^(UITableViewCell* cell, NSUInteger idx, BOOL *stop) {
        
        [AnimationLibrary animateBouncingView:cell];
        
    }];
    
}

@end
