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
#import "SWRevealViewController.h"
#import "RoomRevealWrapperViewController.h"
#import "SHPathLibrary.h"

@implementation ShowGroupsViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager fetchRoomsForUser:[[UserSession sharedSession] user]];
    
    
    [SHPathLibrary addRightCurveBezierPathToView:self.view];
    
    [self.mTableView setContentInset:UIEdgeInsetsMake(70,0,150,0)];
    
    //CGRect testRect = CGRectMake(0, self.mTableView.superview.center.y- 100, self.mTableView.superview.frame.size.width, 200);
    //UIView *testView = [[UIView alloc] initWithFrame:testRect];
    //testView.backgroundColor = [UIColor greenColor];
    //[self.view addSubview:testView];
}

#pragma mark - RoomFetcher

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    self.mGroups = rooms;
    
    [self.mTableView reloadData];
}

- (void)roomManager:(RoomManager *)manager failedToFetchRooms:(NSError*)error{
    // error
}


#pragma mark - UITableView

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Room* room = [self.mGroups objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"groupCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIView* v1 = [cell.contentView viewWithTag:10];
    v1.layer.borderWidth = 1;
    v1.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIView* v2 = [cell.contentView viewWithTag:15];
    v2.layer.borderWidth = 1;
    v2.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:100];
    name.text = room.name;
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mGroups.count;
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToGroupSegue"]) {
        
        NSIndexPath *indexPath = [self.mTableView indexPathForSelectedRow];
        Room* room = [self.mGroups objectAtIndex:indexPath.row];
        NSUInteger selectedRoom = [room.id integerValue];
        
        RoomRevealWrapperViewController* reveal = segue.destinationViewController;
        reveal.roomId = selectedRoom;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //TODO : reset LOOP
    
    NSLog(@"__________");
    
    for (UITableViewCell *cell in self.mTableView.visibleCells) {
        CGRect cellRect = [scrollView convertRect:cell.frame toView:scrollView.superview];
        float cellY = roundf(cellRect.origin.y);
        
        UILabel *name = (UILabel*)[cell.contentView viewWithTag:100];
        //name.text = room.name;
        
        CGPoint center = [scrollView convertPoint:cell.center toView:scrollView.superview];
        NSLog(@"cell: %@ : %@, tableCenter : %@ ", name.text, NSStringFromCGPoint(center) , NSStringFromCGPoint(scrollView.superview.center) );
        if (cellY){
            
            //[self updateThemeDataWithCell:cell];
            //[cell updateAsFullyVisible:YES];
           
        }else{
            //[cell updateAsFullyVisible:NO];
            //NSLog(@"updateAsFullyVisible : NO : %@ : %f", name.text, cellY);
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


@end
