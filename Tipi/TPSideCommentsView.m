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
    self.commentsList.alwaysBounceVertical = NO;
    
}

- (void)commentsQueueManager:(CommentsQueueManager *)manager didPushedComment:(NSDictionary *)comment withReference:(NSNumber*)ref{
    self.comments = manager.commentsQueue;
    
    [self.commentsList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    //[self performSelector:@selector(doTheFuckinReloadWithArray:) withObject:arr afterDelay:1];
}

- (void)commentsQueueManager:(CommentsQueueManager *)manager didRemovedComment:(NSDictionary *)comment withReference:(NSNumber *)ref{
    self.comments = manager.commentsQueue;
    
    
    NSUInteger index = [manager.referencesQueue indexOfObject:ref];
    NSArray *arr = @[[NSIndexPath indexPathForRow:index inSection:0]];
    
    [self.commentsList beginUpdates];
    [self.commentsList deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationLeft];
    [self.commentsList endUpdates];
}

- (void)commentsQueueManager:(CommentsQueueManager *)manager isReadyComment:(NSDictionary *)comment withReference:(NSNumber *)ref atIndexPath:(NSIndexPath *)indexpath{
    
    self.comments = manager.commentsQueue;
    
    NSUInteger index = [self.comments indexOfObject:comment];
    
    [self.commentsList beginUpdates];
    [self.commentsList reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [self.commentsList endUpdates];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UICommentSideCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* comment = [self.comments objectAtIndex:indexPath.row];
    BOOL shown = [[comment objectForKeyedSubscript:@"state"] boolValue];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.contentView.layer.masksToBounds = NO;
    
    if(shown){
        cell.circleContainer.layer.cornerRadius = 20;
        [cell.circleContainer setBackgroundColor :[UIColor whiteColor]];
    }
}

-(UICommentSideCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* comment = [self.comments objectAtIndex:indexPath.row];
    BOOL shown = [[comment objectForKeyedSubscript:@"state"] boolValue];
    
    NSString *cellIdentifier = shown ? @"popCommentCell" : @"hiddenCommentCell" ;
    UICommentSideCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UICommentSideCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    cell.accessoryView.transform = CGAffineTransformMakeScale (1,-1);
    
    UILabel *label = (UILabel*)[cell viewWithTag:10];
    label.text =  [comment objectForKey:@"cap"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UICommentSideCell* cell = (UICommentSideCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell updateState];
    
    /*Comment *comment = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"comment"];
    [self.delegate sideCommentsView:self didSelectedComment:comment withFile:comment.file];*/
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UICommentSideCell* cell = (UICommentSideCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell updateState];
    
    /*Comment *comment = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"comment"];
    [self.delegate sideCommentsView:self didDeselectedComment:comment withFile:comment.file];*/
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
