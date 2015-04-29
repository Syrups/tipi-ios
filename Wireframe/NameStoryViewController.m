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

#pragma mark - TagFetcher

- (void)userManager:(UserManager *)manager successfullyFetchedTags:(NSArray *)tags {
//    [self.latestTagLabel setTitle:[@"Tag : " stringByAppendingString:tags[0]] forState:UIControlStateNormal];
    [[StoryWIPSaver sharedSaver] setTag:tags[0]]; // by default set story tag to the latest one used
}

- (void)userManager:(UserManager *)manager failedToFetchTagsWithError:(NSError *)error {
    // ERROR
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
