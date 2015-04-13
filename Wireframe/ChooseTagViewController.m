//
//  ChooseTagViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ChooseTagViewController.h"
#import "StoryWIPSaver.h"


@interface ChooseTagViewController ()

@end

@implementation ChooseTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    [manager fetchLatestTags];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TagFetcher

- (void)userManager:(UserManager *)manager successfullyFetchedTags:(NSArray *)tags {
    self.tags = tags;
    [self.tagsTableView reloadData];
}

- (void)userManager:(UserManager *)manager failedToFetchTagsWithError:(NSError *)error {
    // ERROR
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
    
    UILabel* tagLabel = (UILabel*)[cell.contentView viewWithTag:10];
    tagLabel.text = [self.tags objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [[StoryWIPSaver sharedSaver] setTag:textField.text];
    
    return YES;
}

@end
