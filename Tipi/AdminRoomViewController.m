//
//  AdminRoomViewController.m
//  Wireframe
//
//  Created by Leo on 29/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AdminRoomViewController.h"
#import "AddUsersToRoomViewController.h"
#import "SHPathLibrary.h"
#import "RoomManager.h"
#import "TPAlert.h"

@interface AdminRoomViewController ()

@end

@implementation AdminRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.roomName.text = self.room.name;
}

- (IBAction)renameRoom:(id)sender {
    NSString* name = [self.roomNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.room.name = name;
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager updateRoom:self.room];
}

- (IBAction)addUsersToRoom:(id)sender {
    AddUsersToRoomViewController* vc = (AddUsersToRoomViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddUsersToRoom"];
    vc.room = self.room;
    vc.roomExists = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RoomUpdater

- (void)roomManager:(RoomManager *)manager successfullyUpdatedRoom:(Room *)room {
    [TPAlert displayOnController:self withMessage:NSLocalizedString(@"Le feu de camp a bien été renommé !", nil) delegate:self];
    self.roomName.text = room.name;
}

- (void)roomManager:(RoomManager *)manager failedToUpdateRoom:(Room *)room withError:(NSError *)error {
    [TPAlert displayOnController:self withMessage:NSLocalizedString(@"Une erreur est survenue, merci de réessayer plus tard", nil) delegate:self];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.room.participants.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    User* user = [self.room.participants objectAtIndex:indexPath.row];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = user.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    UIButton* delete = (UIButton*)[cell.contentView viewWithTag:20];
    
    if (delete.alpha == 0) {
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            label.transform = CGAffineTransformMakeTranslation(100, 0);
            label.alpha = .3f;
            delete.alpha = 1;
        } completion:nil];
    } else {
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            label.transform = CGAffineTransformIdentity;
            label.alpha = 1;
            delete.alpha = 0;
        } completion:nil];
    }
}

#pragma mark - UITextField

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [[event allTouches] anyObject];
    
    if ([self.roomNameField isFirstResponder] && [touch view] != self.roomNameField) {
        [self.roomNameField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)prepareForGoBackToOneGroup:(UIStoryboardSegue *)segue {
    [self.roomNameField resignFirstResponder];
}


@end
