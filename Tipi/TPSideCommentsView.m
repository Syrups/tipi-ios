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
    
    self.commentsList.dataSource = self;
    self.commentsList.delegate = self;
    self.commentsList.transform = CGAffineTransformMakeScale (1,-1);
    self.commentsList.alwaysBounceVertical = NO;
    
    //Player comment
    self.commentsPlayer = [[AVPlayer alloc] init];
    self.commentsPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
}

- (void)commentsQueueManager:(CommentsQueueManager *)manager didPushedComment:(NSDictionary *)comment withReference:(NSNumber*)ref{
    self.comments = manager.commentsQueue;
    
    [self.commentsList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    //[self performSelector:@selector(doTheFuckinReloadWithArray:) withObject:arr afterDelay:1];
}

- (void)commentsQueueManager:(CommentsQueueManager *)manager didRemovedComment:(NSDictionary *)comment atIndex:(NSUInteger)index{
    self.comments = manager.commentsQueue;
    
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
    
    NSDictionary* commentRef = [self.comments objectAtIndex:indexPath.row];
    
    BOOL shown = [[commentRef objectForKeyedSubscript:@"state"] boolValue];
    Comment* comment = [commentRef objectForKey:@"comment"];
    
    NSString *cellIdentifier = shown ? @"popCommentCell" : @"hiddenCommentCell" ;
    UICommentSideCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UICommentSideCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    cell.accessoryView.transform = CGAffineTransformMakeScale (1,-1);
    
    
    if(shown){
        cell.nameLabel.text = cell.unRolled ? comment.user.username : [commentRef objectForKey:@"cap"];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectBubbleView:)];
        [cell.circleContainer addGestureRecognizer:tap];
    }
    
    return cell;
}

-(void)didSelectBubbleView:(UIGestureRecognizer*)sender{
    
    CGPoint pos = [sender.view convertPoint:CGPointZero toView:self.commentsList];
    NSIndexPath* indexPath = [self.commentsList indexPathForRowAtPoint:pos];
    
    if(self.currentBubbleIndex && self.currentBubbleIndex.row == indexPath.row){
        [self sideCommentView:self handleToucheOnRowAtIndexPath:indexPath withSelection:NO];
    }else{
        [self sideCommentView:self handleToucheOnRowAtIndexPath:indexPath withSelection:YES];
        [self sideCommentView:self handleToucheOnRowAtIndexPath:self.currentBubbleIndex withSelection:NO];
        self.currentBubbleIndex = indexPath;
    }
}

- (void)sideCommentView:(TPSideCommentsView *)sideView handleToucheOnRowAtIndexPath:(NSIndexPath *)indexPath withSelection:(BOOL)selected{
    self.currentCommentRef = [self.comments objectAtIndex:indexPath.row];
    BOOL shown = [[self.currentCommentRef objectForKeyedSubscript:@"state"] boolValue];
    Comment* comment = [self.currentCommentRef objectForKey:@"comment"];
    
    UICommentSideCell* cell = (UICommentSideCell*)[sideView.commentsList cellForRowAtIndexPath:indexPath];
    cell.unRolled = !cell.unRolled;
    
    if(shown){
        cell.nameLabel.text = cell.unRolled ? comment.user.username : [self.currentCommentRef objectForKey:@"cap"];
    }
    
    [cell updateState];
    
    if(!self.commentsPlayers){
        self.commentsPlayers = [[NSMutableArray alloc] initWithCapacity:[self.commentsQueueManager.commentsQueue count]];
    }
    
    if(selected){
        if (self.commentsPlayer != nil && [self.commentsPlayer currentItem] != nil){
            [[self.commentsPlayer currentItem] removeObserver:self forKeyPath:@"status"];
            [[self.commentsPlayer currentItem] removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        }
    
        NSURL *comURL = [[NSURL alloc]initWithString:comment.file];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:comURL];
        [playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:0 context:nil];
        //[self.commentsPlayers insertObject:playerItem atIndex: indexPath.row];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];

        
        if(playerItem != self.commentsPlayer.currentItem){
            [self.commentsPlayer replaceCurrentItemWithPlayerItem:playerItem];
            self.commentsPlayer.volume = 1;
            [self.commentsPlayer play];
        }
    
        [self.delegate sideCommentsView:self didSelectComment:comment];
    }else{
        [self.commentsPlayer pause];
        [self.delegate sideCommentsView:self didDeselectComment:comment];
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    [self.commentsPlayer pause];
    [self.delegate sideCommentsView:self comment:nil didFinishedPlaying:YES];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[AVPlayerItem class]])
    {
        AVPlayerItem *item = (AVPlayerItem *)object;
        //playerItem status value changed?
        if ([keyPath isEqualToString:@"status"])
        {   //yes->check it...
            switch(item.status)
            {
                case AVPlayerItemStatusFailed:
                    NSLog(@"player item status failed");
                    break;
                case AVPlayerItemStatusReadyToPlay:
                    NSLog(@"player item status is ready to play");
                    break;
                case AVPlayerItemStatusUnknown:
                    NSLog(@"player item status is unknown");
                    break;
            }
        }
        else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
        {
            if (item.playbackBufferEmpty)
            {
                NSLog(@"player item playback buffer is empty");
            }
        }
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
