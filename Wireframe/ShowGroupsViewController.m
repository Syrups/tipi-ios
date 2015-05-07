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
#import "SHPathLibrary.h"

@implementation ShowGroupsViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mTableView setContentInset:UIEdgeInsetsMake(70,0,150,0)];
    [SHPathLibrary addRightCurveBezierPathToView:self.view inverted:NO];
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager fetchRoomsForUser:[[UserSession sharedSession] user]];
}

- (IBAction)createNewRoom:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateRoom"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RoomFetcher

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    self.mGroups = rooms;
    
    [self.mTableView reloadData];
    [self.mTableView setContentOffset:CGPointMake(0.0f, -self.mTableView .contentInset.bottom) animated:NO];
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


@end
