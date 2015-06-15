//
//  DeleteRoomModalViewController.m
//  Tipi
//
//  Created by Leo on 14/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "DeleteRoomModalViewController.h"
#import "ShowGroupsViewController.h"
#import "TPAlert.h"

@implementation DeleteRoomModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.centerYConstraint.constant = self.view.frame.size.height;
    [self.view layoutIfNeeded];
    
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.6f animations:^{
            self.centerYConstraint.constant = -30;
            [self.view layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:.6f relativeDuration:.4f animations:^{
            self.centerYConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    } completion:nil];
}

- (IBAction)close:(id)sender {
    
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5f animations:^{
            self.centerYConstraint.constant = 30;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:.5f relativeDuration:.5f animations:^{
            self.centerYConstraint.constant = -self.view.frame.size.height;
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }];
}

- (IBAction)delete:(id)sender {
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager deleteRoom:self.room];
}


#pragma mark - RoomDeleter

- (void)roomManager:(RoomManager *)manager successfullyDeletedRoom:(Room *)room {
    [self close:nil];
    
    ShowGroupsViewController* parent = (ShowGroupsViewController*)self.parentViewController;
    
    NSMutableArray* mRooms = [parent.mGroups mutableCopy];
    
    [mRooms removeObject:self.room];
    
    parent.mGroups = [mRooms copy];
    
    [[(ShowGroupsViewController*)self.parentViewController mTableView] reloadData];
    
    [TPAlert displayOnController:parent withMessage:@"Le feu de camp a bien été supprimé" delegate:nil];
}

- (void)roomManager:(RoomManager *)manager failedToDeleteRoom:(Room *)room withError:(NSError *)error {
    [TPAlert displayOnController:self.parentViewController withMessage:NSLocalizedString(@"Une erreur est survenue, merci de réessayer plus tard", nil) delegate:nil];
    [self close:nil];
    
    
}

@end
