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
    [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:.7f initialSpringVelocity:.05f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.centerYConstraint.constant = 80;
        [self.view layoutIfNeeded];
        
        [self.titleField becomeFirstResponder];
    } completion:nil];
}

- (IBAction)close:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
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
