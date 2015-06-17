//
//  TagMenuViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 04/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TagMenuViewController.h"

@interface TagMenuViewController ()

@end



@implementation TagMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    [manager fetchLatestTags];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TagFetcher

- (void)userManager:(UserManager *)manager successfullyFetchedTags:(NSArray *)tags {
    // TODO
    
    NSMutableArray* goodTags = [NSMutableArray array];
    
    for (NSString* tag in tags) {
        if (tag != nil && ![tag isEqual:[NSNull null]] && ![tag isEqualToString:@""]) {
            [goodTags addObject:tag];
        }
    }
    
    self.mTags = [goodTags copy];
    [self.mTableView reloadData];
}

- (void)userManager:(UserManager *)manager failedToFetchTagsWithError:(NSError *)error {
    // TODO
}

#pragma mark - UITableView

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"tagItem";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:10];
    name.text = [self.mTags objectAtIndex:indexPath.row];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mTags.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.parent setFilterTag:[self.mTags objectAtIndex:indexPath.row]];
    [self.parent applyFilters];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:10];
    name.alpha = 1;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:10];
    name.alpha = .5f;
}


@end
