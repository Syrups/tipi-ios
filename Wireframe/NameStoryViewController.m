//
//  NameStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NameStoryViewController.h"
#import "StoryWIPSaver.h"

@implementation NameStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    [manager fetchLatestTags];
    
    self.centerYConstraint.constant = self.view.frame.size.height;
    [self.view layoutIfNeeded];
    
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.6f animations:^{
            self.centerYConstraint.constant = -30;
            [self.view layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:.6f relativeDuration:.4f animations:^{
            self.centerYConstraint.constant = 100;
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        [self.titleField becomeFirstResponder];
    }];
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

- (IBAction)next:(id)sender {
    [[StoryWIPSaver sharedSaver] setTitle:[self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomPicker"];
    [self.parentViewController.navigationController.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MLPAutoCompleteTextField

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string {
    NSMutableArray* possibles = [NSMutableArray array];
    for (NSString* tag in self.latestTags) {
        if (tag != (NSString*)[NSNull null] && [tag containsString:string]) {
            [possibles addObject:tag];
        }
    }
    
    return possibles.copy;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    autoCompleteTableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - TagFetcher

- (void)userManager:(UserManager *)manager successfullyFetchedTags:(NSArray *)tags {
//    [self.latestTagLabel setTitle:[@"Tag : " stringByAppendingString:tags[0]] forState:UIControlStateNormal];
//    [[StoryWIPSaver sharedSaver] setTag:tags[0]]; // by default set story tag to the latest one used
    
    self.latestTags = tags;
}

- (void)userManager:(UserManager *)manager failedToFetchTagsWithError:(NSError *)error {
    // ERROR
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
