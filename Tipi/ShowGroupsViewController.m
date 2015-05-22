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

@implementation ShowGroupsViewController {
    CAGradientLayer* maskLayer;
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mGroups = [NSArray array];
    
    [self.mTableView setContentInset:UIEdgeInsetsMake(70,0,150,0)];
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager fetchRoomsForUser:[[UserSession sharedSession] user]];
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
    [self.view sendSubviewToBack:loader];
    
    CGFloat initialConstant = self.topControlsYConstraint.constant;
    self.topControlsYConstraint.constant = -100;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.5f animations:^{
        self.topControlsYConstraint.constant = initialConstant;
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!maskLayer) {
        maskLayer = [CAGradientLayer layer];
        
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
        CGColorRef innerColor = kListenBackgroundColor.CGColor;
        
        maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                            (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.1],
                               [NSNumber numberWithFloat:0.9],
                               [NSNumber numberWithFloat:1.0], nil];
        
        maskLayer.bounds = CGRectMake(0, 0,
                                      self.mTableView.frame.size.width,
                                      self.mTableView.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        
        self.mTableView.layer.mask = maskLayer;
    }
}

//- (IBAction)createNewRoom:(id)sender {
//    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateRoom"];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (IBAction)backToHome:(id)sender {
    HomeViewController* parent = (HomeViewController*)self.parentViewController.parentViewController;
    [parent displayChildViewController:parent.storyViewController];
}

#pragma mark - RoomFetcher

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    
    BOOL first = self.mGroups.count == 0;
    
    [loader removeFromSuperview];
    
    self.mGroups = rooms;
    
    [self.mTableView reloadData];
    [self.mTableView setContentOffset:CGPointMake(0.0f, -self.mTableView .contentInset.bottom) animated:NO];
    
    if(rooms.count >= 2){
        NSIndexPath *pathForCenterCell = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    if(first){
        [self animate];
    }
}

- (void)roomManager:(RoomManager *)manager failedToFetchRooms:(NSError*)error{
    // error
}


#pragma mark - UITableView

- (UIRoomTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Room* room = [self.mGroups objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"groupCell";
    UIRoomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UIRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    cell.roomName.text = room.name;
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mGroups.count;
}


#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // Keep the gradient fixed in view
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
    
    for (UIRoomTableViewCell *cell in self.mTableView.visibleCells) {
        CGPoint cellCenter = [scrollView convertPoint:cell.center toView:scrollView.superview];
        
        int del = fabs(scrollView.superview.center.y -  cellCenter.y)/ 4.5;
        
        cell.heightConstraint.constant = 120 - del;
        cell.widthConstraint.constant = 120 - del;
        
        [cell setNeedsLayout];
        [cell setNeedsUpdateConstraints];
        
        CGRect cellRect = [scrollView convertRect:cell.frame toView:scrollView.superview];
        CGRect hitRect = CGRectMake(0, self.mTableView.superview.center.y- 25, self.mTableView.superview.frame.size.width, 50);
        
        if(CGRectIntersectsRect(cellRect, hitRect)){
            [self.mTableView selectRowAtIndexPath: [self.mTableView indexPathForCell:cell]
                                         animated: NO
                                   scrollPosition: UITableViewScrollPositionNone];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self centerTable];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self centerTable];
}

- (void)centerTable {
    
    NSIndexPath *pathForCenterCell = [self.mTableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.mTableView.bounds), CGRectGetMidY(self.mTableView.bounds) - 100)];
    [self.mTableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark - UIStoryboardSegue

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToGroupSegue"]) {
        
        NSIndexPath *indexPath = [self.mTableView indexPathForSelectedRow];
        Room* room = [self.mGroups objectAtIndex:indexPath.row];
        //NSUInteger selectedRoom = [room.id integerValue];
        
        ShowOneGroupViewController* reveal = segue.destinationViewController;
        reveal.room = room;
    }
}

- (void)animate
{
    [[self.mTableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        
        int endY = cell.frame.origin.y;
        float delay = idx * 0.1;
        
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y + 150, cell.frame.size.width, cell.frame.size.height)];
        [cell setAlpha:0];
        
        [UIView animateWithDuration:.3f delay:delay  options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [cell setFrame:CGRectMake(cell.frame.origin.x, endY, cell.frame.size.width, cell.frame.size.height)];
            [cell setAlpha:1];
        } completion:nil];
    }];
}


@end
