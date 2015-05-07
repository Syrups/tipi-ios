//
//  AdminRoomViewController.m
//  Wireframe
//
//  Created by Leo on 29/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AdminRoomViewController.h"

@interface AdminRoomViewController ()

@end

@implementation AdminRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.room.users.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    User* user = [self.room.users objectAtIndex:indexPath.row];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = user.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        label.transform = CGAffineTransformMakeTranslation(100, 0);
        label.alpha = .3f;
    } completion:nil];
    
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

-(IBAction)prepareForGoBackToOneGroup:(UIStoryboardSegue *)segue {
}


@end
