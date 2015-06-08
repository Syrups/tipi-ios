//
//  CommentListViewController.m
//  Tipi
//
//  Created by Leo on 08/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CommentListViewController.h"
#import "Comment.h"

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
