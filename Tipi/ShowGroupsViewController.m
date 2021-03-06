//
//  ShowGroupsViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowGroupsViewController.h"
#import "ShowOneGroupViewController.h"
#import "UserSession.h"
#import "CreateRoomViewController.h"
#import "HomeViewController.h"
#import "TPLoader.h"
#import "SHPathLibrary.h"
#import "DeleteRoomModalViewController.h"
#import <UIView+MTAnimation.h>

@implementation ShowGroupsViewController {
    CAGradientLayer* maskLayer;
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mGroups = [NSArray array];
    
    [self.mTableView setContentInset:UIEdgeInsetsMake(40,0,150,0)];
//    self.mTableView.alwaysBounceVertical = NO;
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager fetchRoomsForUser:[[UserSession sharedSession] user]];
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
    [self.view sendSubviewToBack:loader];
    
    CGFloat initialConstant = self.topControlsYConstraint.constant;
    self.topControlsYConstraint.constant = - 150;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.3f animations:^{
        self.topControlsYConstraint.constant = initialConstant;
        [self.view layoutIfNeeded];
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mTableView.delegate = self;
    
//    if (!maskLayer) {
//        maskLayer = [CAGradientLayer layer];
//        
//        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
//        CGColorRef innerColor = kListenBackgroundColor.CGColor;
//        
//        maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
//                            (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
//        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
//                               [NSNumber numberWithFloat:0.3],
//                               [NSNumber numberWithFloat:0.9],
//                               [NSNumber numberWithFloat:1.0], nil];
//        
//        maskLayer.bounds = CGRectMake(0, 0,
//                                      self.mTableView.frame.size.width,
//                                      self.mTableView.frame.size.height);
//        maskLayer.anchorPoint = CGPointZero;
//        
//        self.mTableView.layer.mask = maskLayer;
//    }
}

//- (IBAction)createNewRoom:(id)sender {
//    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateRoom"];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (IBAction)backToHome:(id)sender {
    [self animateBackWithCompletion:^(BOOL finished) {
        self.mTableView.delegate = nil;
        self.mTableView.contentOffset = CGPointMake(0, 0);
        HomeViewController* parent = (HomeViewController*)self.parentViewController.parentViewController;
        [parent displayChildViewController:parent.storyViewController];
    }];
}

#pragma mark - Deletion

- (IBAction)deleteRoom:(id)sender {
    
    // retrieve story object
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.mTableView];
    NSIndexPath *indexPath = [self.mTableView indexPathForRowAtPoint:buttonPosition];
    Room* room = [self.mGroups objectAtIndex:indexPath.row];
    
    DeleteRoomModalViewController* modal = [self.storyboard instantiateViewControllerWithIdentifier:@"DeleteRoom"];
    modal.room = room;
    
    [self addChildViewController:modal];
    modal.view.frame = self.view.frame;
    [self.view addSubview:modal.view];
    [modal didMoveToParentViewController:self];
}

#pragma mark - RoomFetcher

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    [loader removeFromSuperview];
    
    BOOL first = (self.mGroups.count == 0);
    self.mGroups = rooms;

    [self.mTableView reloadData];

    if(first){
        [self animate];
    }
}

- (void)roomManager:(RoomManager *)manager failedToFetchRooms:(NSError*)error{
    // error
    [TPAlert displayOnController:self withMessage:@"Impossible de charger les feux de camp" delegate:nil];
}


#pragma mark - UITableView

- (UIRoomTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Room* room = [self.mGroups objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"groupCell";
    UIRoomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UIRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIImageView* pic = (UIImageView*)[cell.contentView viewWithTag:90];

    if (room.tipi_room && [room.tipi_room isEqualToString:@"1"]) {
        pic.image = [UIImage imageNamed:@"picto-fire-tipi"];
    } else {
        pic.image = [UIImage imageNamed:@"picto-fire-b"];
    }
    
    cell.isSwipeDeleteEnabled = [room isAdmin:CurrentUser];
    
    cell.roomName.text = room.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mGroups.count;
}


#pragma mark - UIScrollView


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self centerTable];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    [self centerTable];
}

- (void)centerTable {
    
    NSIndexPath *pathForCenterCell = [self.mTableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.mTableView.bounds), CGRectGetMidY(self.mTableView.bounds) - 100)];
    [self.mTableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ToGroupSegue"]) {
        NSIndexPath* indexPath = [self.mTableView indexPathForSelectedRow];
        TPSwipeDeleteTableViewCell* cell = (TPSwipeDeleteTableViewCell*)[self.mTableView cellForRowAtIndexPath:indexPath];
        
        return !cell.editMode;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToGroupSegue"]) {
        
        NSIndexPath *indexPath = [self.mTableView indexPathForSelectedRow];
        Room* room = [self.mGroups objectAtIndex:indexPath.row];
        //NSUInteger selectedRoom = [room.id integerValue];
        
        ShowOneGroupViewController* reveal = segue.destinationViewController;
        reveal.room = room;
    }
    
    if ([segue.identifier isEqualToString:@"ToCreate"]) {
        CreateRoomViewController* vc = (CreateRoomViewController*)segue.destinationViewController;
        vc.roomsController = self;
    }
}

#pragma mark - Animation

- (void)animate {
    [[self.mTableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        
        int endY = cell.frame.origin.y;
        float delay = idx * 0.05;
        
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y + self.view.frame.size.height, cell.frame.size.width, cell.frame.size.height)];
        [cell setAlpha:0];
        
        
        [UIView animateWithDuration:.23f delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            [cell setAlpha:1];
            [cell setFrame:CGRectMake(cell.frame.origin.x, endY + 100, cell.frame.size.width, cell.frame.size.height)];
        } completion:^(BOOL finished) {
            [UIView mt_animateWithViews:@[cell] duration:1.3f delay:0 timingFunction:kMTEaseOutElastic animations:^{
                [cell setFrame:CGRectMake(cell.frame.origin.x, endY, cell.frame.size.width, cell.frame.size.height)];
            } completion:nil];
        }];
    }];
}

- (void)animateBackWithCompletion:(void(^)(BOOL finished))completion {
    
    if (self.mGroups.count == 0) completion(YES);
    
    [[self.mTableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        
        int endY = cell.frame.origin.y + 200;
        float delay = (self.mTableView.visibleCells.count - idx - 1) * 0.1f;

        
        [UIView mt_animateWithViews:@[cell] duration:.3f delay:delay timingFunction:kMTEaseInBack animations:^{
            [cell setFrame:CGRectMake(cell.frame.origin.x, endY, cell.frame.size.width, cell.frame.size.height)];
            [cell setAlpha:0];
        } completion:^{
            if (idx == self.mTableView.visibleCells.count - 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .25f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    completion(YES);
                });
            }
        }];
    }];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
