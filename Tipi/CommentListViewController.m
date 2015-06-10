//
//  CommentListViewController.m
//  Tipi
//
//  Created by Leo on 08/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CommentListViewController.h"
#import "AnimationLibrary.h"

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentsTableView.alpha = 0;
}

- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:.3f animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        self.commentsTableView.alpha = 0;
        self.view.alpha = 0;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment* comment = [self.comments objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(commentListViewController:didSelectComment:)]) {
        [self.delegate commentListViewController:self didSelectComment:comment];
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

- (void)appear {
    self.commentsTableView.alpha = 1;
    [self.commentsTableView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [AnimationLibrary animateBouncingView:obj withDelay:idx * .05f];
    }];
}

@end
