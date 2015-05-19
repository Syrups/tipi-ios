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

- (void)commentsQueueManager:(CommentsQueueManager *)manager didPushedComment:(Comment*)comment withReference:(NSNumber*)ref{
    self.comments = manager.commentsQueue;
    
    NSArray *arr = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    NSMutableArray *indexes = [NSMutableArray new];
    
    if(self.comments.count > 1){
        for (int i = 1; i < self.comments.count ; i++) {
            [indexes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    
    [self.commentsList reloadData];
    
    [self.commentsList reloadRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationBottom];
    [self.commentsList reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationRight];
    
}

- (void)commentsQueueManager:(CommentsQueueManager *)manager didRemovedComment:(Comment *)comment withReference:(NSNumber *)ref{
    self.comments = manager.commentsQueue;
    
    [self.commentsList beginUpdates];
    
    NSUInteger index = [manager.referencesQueue indexOfObject:ref];
    
    NSArray *arr = @[[NSIndexPath indexPathForRow:index inSection:0]];
    [self.commentsList deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationLeft];
    [self.commentsList endUpdates];
    
    [self.commentsList reloadData];
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
    label.text =  comment.user.username;
    
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
