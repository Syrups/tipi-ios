//
//  OrganizeStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "OrganizeStoryViewController.h"
#import "RecordViewController.h"
#import "DoneStoryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageUtils.h"

#define CELL_SIZE 190
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
    
    // Okay, so we load the first XX images in full resolution
    // so they can display immediately on collection view,
    // while we load all the others in the background thread.
    
    [self.saver.medias enumerateObjectsUsingBlock:^(NSMutableDictionary* media, NSUInteger idx, BOOL *stop) {
        
        if (idx < 4) {
            ALAsset* asset = (ALAsset*)[media objectForKey:@"asset"];
            UIImage* full = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            [media setObject:full forKey:@"full"];
            
            if (idx == 0) {
                [self.wave updateImage:[ImageUtils convertImageToGrayScale:full]];
            }
        }
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.saver.medias enumerateObjectsUsingBlock:^(NSMutableDictionary* media, NSUInteger idx, BOOL *stop) {
            ALAsset* asset = (ALAsset*)[media objectForKey:@"asset"];
            UIImage* full = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            [media setObject:full forKey:@"full"];
            
            if (idx == self.saver.medias.count-1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }];
    });

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.replayButton.alpha = 1;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.saver.medias.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:20];
    image.layer.mask = [self maskForCell:cell expanded:NO];
    
    NSDictionary* media = [self.saver.medias objectAtIndex:indexPath.row];
    [image setImage:[media objectForKey:@"full"]];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    
    
    if (indexPath.row == 0 && !firstLoad) {
        //        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.2f, 1.2f), CGAffineTransformMakeRotation(ACTIVE_CELL_ROTATION));
        firstLoad = YES;
    } else {
        //        cell.alpha = INACTIVE_CELL_OPACITY;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* media = [self.saver.medias objectAtIndex:indexPath.row];
    UIImage* image = [media objectForKey:@"full"];
    
    NSLog(@"%@", image);
    
//    if (image != nil) {
        CGFloat ratio = image.size.height / image.size.width;
        
        if (ratio > 1)
            return CGSizeMake(CELL_SIZE, CELL_SIZE * ratio);
//    }
    
    return CGSizeMake(CELL_SIZE, CELL_SIZE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(130, (collectionView.frame.size.width-CELL_SIZE)/2, 120, collectionView.frame.size.width/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.saver.medias.count) return;
    
    selectedPageIndex = indexPath.row;
    [self zoomAtIndexPath:indexPath];
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


- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.transform = CGAffineTransformMakeRotation(0);
    
    NSLog(@"%f", cell.bounds.origin.y);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    CGPoint point = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    NSIndexPath* visibleIndexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    return visibleIndexPath.row == indexPath.row;
}

#pragma mark - UIScrollView

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint point = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:point];
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.2f, 1.2f), CGAffineTransformMakeRotation(ACTIVE_CELL_ROTATION));
        
        [self.wave updateImage:[ImageUtils convertImageToGrayScale:[self mediaForIndexPath:indexPath]]];
        
        cell.layer.zPosition = 100;
        cell.alpha = 1;
        self.pageLabel.text = [NSString stringWithFormat:@"page %d", indexPath.row+1];
    } completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint point = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:point];
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeRotation(0));
        cell.layer.zPosition = 0;
//        cell.alpha = INACTIVE_CELL_OPACITY;
    } completion:nil];
}

#pragma mark - Navigation

- (void)zoomAtIndexPath:(NSIndexPath*)indexPath {
    RecordViewController* vc = (RecordViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record"];
    vc.currentIndex = selectedPageIndex;
    
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];

    cell.layer.zPosition = 1000;
    
    CGRect originalCellFrame = cell.frame;
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:20];
    CAShapeLayer* originalMask = image.layer.mask;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:.2f] forKey:kCATransactionAnimationDuration];
    
    image.layer.mask = nil;
    
    [CATransaction commit];
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        CGFloat scale = self.view.frame.size.height / cell.frame.size.height;
        cell.transform = CGAffineTransformMakeScale(scale, scale);
        self.replayButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.navigationController pushViewController:vc animated:NO];
        image.layer.mask = originalMask;
        cell.transform = CGAffineTransformMakeScale(1, 1);
        cell.frame = originalCellFrame;
    }];
}

- (void)openDonePopin {
    DoneStoryViewController* done = (DoneStoryViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"DoneStory"];
    
    [self addChildViewController:done];
    done.view.frame = self.view.frame;
    [self.view addSubview:done.view];
    [done didMoveToParentViewController:self];
}

#pragma mark - Helper

- (UIImage*)mediaForIndexPath:(NSIndexPath*)indexPath {
    NSDictionary* media = [self.saver.medias objectAtIndex:indexPath.row];
    
    if (media) {
        UIImage* image = [media objectForKey:@"full"];
        return image;
    }
    
    return nil;
}

- (CAShapeLayer*)maskForCell:(UICollectionViewCell*)cell expanded:(BOOL)expanded {
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = expanded ? cell.bounds : CGRectMake(0, cell.frame.size.height/2 - CELL_SIZE/2 + 10, CELL_SIZE, CELL_SIZE);
    CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
    maskLayer.path = path;
    CGPathRelease(path);
    
    return maskLayer;
}


@end
