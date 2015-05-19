//
//  TPSideCommentsView.m
//  Wireframe
//
//  Created by Glenn Sonna on 19/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPSideCommentsView.h"
#import "UICommentSideCell.h"

@implementation TPSideCommentsView

- (void)awakeFromNib{
    
    self.comments = [NSMutableArray new];
    self.commentsList.dataSource = self;
    self.commentsList.delegate = self;
    
    self.commentsList.transform = CGAffineTransformMakeScale (1,-1);
    
}

- (void)commentsQueueManager:(CommentsQueueManager *)manager didPushedComment:(Comment*)comment atIndex:(NSUInteger)index{
    self.comments = manager.commentsQueue;
    [self.commentsList reloadData];
    
    
    NSArray *arr = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.commentsList reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationLeft];
    //[self.commentsList reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)commentsQueueManager:(CommentsQueueManager *)manager didRemovedComment:(Comment*)comment atIndex:(NSUInteger)index{
    self.comments = manager.commentsQueue;
    
    [self.commentsList reloadData];
    //NSArray *arr = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    //[self.commentsList reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationRight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment* comment = [self.comments objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"popCommentCell";
    UICommentSideCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UICommentSideCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //cell.roomName.text = room.name;
    
    cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    // if you have an accessory view
    cell.accessoryView.transform = CGAffineTransformMakeScale (1,-1);
    
    UILabel *label = (UILabel*)[cell viewWithTag:10];
    label.text =  comment.file;
    
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
