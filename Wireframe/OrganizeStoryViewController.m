//
//  OrganizeStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "OrganizeStoryViewController.h"
#import "RecordViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CELL_SIZE 180
#define INACTIVE_CELL_OPACITY 0.3f
#define ACTIVE_CELL_ROTATION 0.05f

@implementation OrganizeStoryViewController {
    NSString* oldHelpText;
    NSUInteger selectedPageIndex;
    CGFloat lastOffset;
    NSUInteger currentMedia;
    BOOL firstLoad;
}

- (void)viewDidLoad {
    currentMedia = 1;
    LXReorderableCollectionViewFlowLayout* layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.longPressGestureRecognizer.minimumPressDuration = 0;
    layout.scrollingSpeed = 400;
    
    self.collectionView.collectionViewLayout = layout;
    
    self.saver = [StoryWIPSaver sharedSaver];
    
    

}

- (IBAction)start:(id)sender {
    [self performSegueWithIdentifier:@"ToRecord" sender:nil];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.saver.medias.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= self.saver.medias.count-1) {
        return [self cellForMediaAtIndexPath:indexPath];
    }
    
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AddPageCell" forIndexPath:indexPath];
}

- (UICollectionViewCell*)cellForMediaAtIndexPath:(NSIndexPath*)indexPath {
    UICollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:20];
    NSDictionary* media = [self.saver.medias objectAtIndex:indexPath.row];
    [image setImage:[media objectForKey:@"image"]];
    
    UIView* vidIcon = (UIView*)[cell.contentView viewWithTag:30];
    
    if ([[media objectForKey:@"type"] isEqual:ALAssetTypeVideo]) {
        vidIcon.hidden = NO;
    } else {
        vidIcon.hidden = YES;
    }
    
    
    if (indexPath.row == 0 && !firstLoad) {
        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.2f, 1.2f), CGAffineTransformMakeRotation(ACTIVE_CELL_ROTATION));
        firstLoad = YES;
    } else {
        cell.alpha = INACTIVE_CELL_OPACITY;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CELL_SIZE, CELL_SIZE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, (collectionView.frame.size.width-CELL_SIZE)/2, 0, (collectionView.frame.size.width-CELL_SIZE)/5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.saver.medias.count) return;
    
    selectedPageIndex = indexPath.row;
    [self performSegueWithIdentifier:@"ToRecord" sender:nil];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:fromIndexPath];
    
    id media = [self.saver.medias objectAtIndex:fromIndexPath.row];
    [self.saver.medias removeObjectAtIndex:fromIndexPath.row];
    [self.saver.medias insertObject:media atIndex:toIndexPath.row];
    
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%ld sur %ld", (unsigned long)[self.saver.medias indexOfObject:media], (unsigned long)self.saver.medias.count];
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    self.helpLabel.text = oldHelpText;
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeRotation(0);
    
    NSLog(@"%f", cell.bounds.origin.y);
}

#pragma mark - UIScrollView

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint point = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:point];
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.2f, 1.2f), CGAffineTransformMakeRotation(ACTIVE_CELL_ROTATION));
        cell.layer.zPosition = 100;
        cell.alpha = 1;
    } completion:nil];
    
    [self.wave shuffle];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint point = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:point];
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeRotation(0));
        cell.layer.zPosition = 0;
        cell.alpha = INACTIVE_CELL_OPACITY;
    } completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToRecord"]) {
        RecordViewController* vc = (RecordViewController*)[segue destinationViewController];
        vc.currentIndex = selectedPageIndex;
    }
}


@end
