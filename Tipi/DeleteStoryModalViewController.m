//
//  DeleteStoryModalViewController.m
//  Tipi
//
//  Created by Leo on 10/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "DeleteStoryModalViewController.h"
#import "ShowOneGroupViewController.h"

@implementation DeleteStoryModalViewController

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
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    // todo
    [manager deleteStory:self.story inRoom:self.room];
}

- (IBAction)deleteAndReport:(id)sender {
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    // todo report
    [manager deleteStory:self.story inRoom:self.room];
}

#pragma mark - StoryDeleter

- (void)storyManager:(StoryManager *)manager successfullyDeletedStoryInRoom:(Room *)room {
    [self close:nil];
    [[(ShowOneGroupViewController*)self.parentViewController mTableView] reloadData];
}

- (void)storyManager:(StoryManager *)manager failedToDeleteStory:(Story *)story inRoom:(Room *)room withError:(NSError *)error {
    // TODO
}

@end
