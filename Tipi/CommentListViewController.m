//
//  CommentListViewController.m
//  Tipi
//
//  Created by Leo on 08/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CommentListViewController.h"
#import "AnimationLibrary.h"
#import "FileDownLoader.h"
#import "TPCircleWaverControl.h"
#import <UIView+MTAnimation.h>

@implementation CommentListViewController {
    NSIndexPath* currentIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentsTableView.alpha = 0;
    self.commentsTableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
}

- (IBAction)dismiss:(id)sender {
    
    if (self.player != nil) {
        [self.player stop];
    }
    
    [UIView animateWithDuration:.3f animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        self.commentsTableView.alpha = 0;
        self.view.alpha = 0;
    }];
    
    [self.commentsTableView reloadData];
    currentIndexPath = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (currentIndexPath != nil) {
        return;
    }
    
    Comment* comment = [self.comments objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(commentListViewController:didSelectComment:)]) {
        [self.delegate commentListViewController:self didSelectComment:comment];
    }
    
    NSError* err = nil;
    NSData *soundData = [NSData dataWithContentsOfURL:[NSURL URLWithString:comment.file]];
    
    self.player = [[AVAudioPlayer alloc] initWithData:soundData error:&err];
    self.player.delegate = self;
    
    if (!err) {
        currentIndexPath = indexPath;
        
        TPCircleWaverControl* control = (TPCircleWaverControl*)[cell.contentView viewWithTag:30];
        [control appear];
        control.alpha = 1;
        
        control.audioPlayer = self.player;
        control.autoStart = YES;
        
        
        [self.player play];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    Comment* comment = [self.comments objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    
    UILabel* username = (UILabel*)[cell.contentView viewWithTag:10];
    username.text = @"leoht";
    
    UILabel* time = (UILabel*)[cell.contentView viewWithTag:20];
    time.text = [NSString stringWithFormat:@"%d secondes", comment.duration];
    
    return cell;
}

#pragma mark - AVAudioPlayer

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    UITableViewCell* cell = [self.commentsTableView cellForRowAtIndexPath:currentIndexPath];
    TPCircleWaverControl* control = (TPCircleWaverControl*)[cell.contentView viewWithTag:30];
    [control close];
    currentIndexPath = nil;
}

- (void)appear {
    self.commentsTableView.alpha = 1;
    [self.commentsTableView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [AnimationLibrary animateBouncingView:obj withDelay:idx * .05f];
    }];
}

@end
