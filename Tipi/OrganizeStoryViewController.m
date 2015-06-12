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
#import "NameStoryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageUtils.h"
#import "MediaCell.h"
#import "CoachmarkManager.h"

@implementation OrganizeStoryViewController {
    NSUInteger selectedPageIndex;
    NSUInteger currentMedia;
    BOOL firstLoad;
    BOOL removing;
    NSInteger pendingCellToRemoveIndex;
}

- (void)viewDidLoad {
    currentMedia = 1;
    RAReorderableLayout* layout = [[RAReorderableLayout alloc] init];
    layout.delegate = self;
    layout.datasource = self;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.scrollSpeedValue = 5;
    
    self.saver = [StoryWIPSaver sharedSaver];
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    
    pendingCellToRemoveIndex = -1;
    
    self.collectionView.collectionViewLayout = layout;
    
//    [self loadFullImages];
    
//    self.view.alpha = .5f;
    
}

- (void)loadFullImages {
    
    // We load the first XX images in full resolution
    // so they can display immediately on collection view,
    // while we load all the others in the background thread.
    
    [self.saver.medias enumerateObjectsUsingBlock:^(NSMutableDictionary* media, NSUInteger idx, BOOL *stop) {
        
//        if (idx < 4) {
        ALAsset* asset = (ALAsset*)[media objectForKey:@"asset"];
        UIImage* full = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        
        // reduce image if it's too big
        if (full.size.width > 1500) {
            full = [ImageUtils scaleImage:full toSize:CGSizeMake(full.size.width/2, full.size.height/2) mirrored:NO];
        }
        
        full = [ImageUtils compressImage:full withQuality:.5f];
        
        [media setObject:full forKey:@"full"];
//        }
        
    }];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [self.saver.medias enumerateObjectsUsingBlock:^(NSMutableDictionary* media, NSUInteger idx, BOOL *stop) {
//            ALAsset* asset = (ALAsset*)[media objectForKey:@"asset"];
//            UIImage* full = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//            [media setObject:full forKey:@"full"];
//            
//            if (idx == self.saver.medias.count-1) {
//                [self.collectionView reloadData];
//            }
//        }];
//    });
}

#pragma mark - Media deletion

- (void)toggleRemoveState:(UIPanGestureRecognizer*)sender {
    
    CGPoint t = [sender translationInView:self.view];
    
    if (sender.view.tag != pendingCellToRemoveIndex && t.y < -2) {
        pendingCellToRemoveIndex = sender.view.tag;
        
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pendingCellToRemoveIndex inSection:0]];
        UIButton *delete = (UIButton*)[cell.contentView viewWithTag:30];
        
        [UIView animateKeyframesWithDuration:.3f delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.4f animations:^{
                delete.alpha = 1;
                delete.enabled = YES;
                cell.transform = CGAffineTransformMakeTranslation(0, -90);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.4f relativeDuration:.6f animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, -70);
            }];
            
        } completion:nil];
    } else if (t.y > 2) {
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pendingCellToRemoveIndex inSection:0]];
        
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            UIButton *delete = (UIButton*)[cell.contentView viewWithTag:30];
            delete.alpha = 0;
            delete.enabled = NO;
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            pendingCellToRemoveIndex = -1;
        }];
    }
}

- (IBAction)deleteMedia:(id)sender {
    if (removing) return;
    removing = YES;
    
    if (pendingCellToRemoveIndex < self.saver.medias.count) {
        
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pendingCellToRemoveIndex inSection:0]];
        
        [UIView animateWithDuration:.3f animations:^{
            cell.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [self.saver.medias removeObjectAtIndex:pendingCellToRemoveIndex];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            } completion:^(BOOL finished) {
                removing = NO;
                pendingCellToRemoveIndex = -1;
            }];
        }];
    }
    
    // if all has been deleted, go back to picker
    if (self.saver.medias.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.saver.medias.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MediaCell alloc] init];
    }
    
    NSDictionary* media = [self.saver.medias objectAtIndex:indexPath.row];
    
//    if ([[media objectForKey:@"type"] isEqual:ALAssetTypeVideo]) {
//        [cell launchVideoPreviewWithUrl:[media objectForKey:@"url"]];
//    } else {
//        [cell.playerLayer removeFromSuperlayer];
//    }
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:20];
    
    [image setImage:[media objectForKey:@"image"]];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    
    cell.contentView.tag = indexPath.row;
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRemoveState:)];
    pan.delegate = self;
    [cell.contentView addGestureRecognizer:pan];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.contentView.bounds];
    cell.contentView.layer.masksToBounds = NO;
    cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.contentView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    cell.contentView.layer.shadowOpacity = 0.5f;
    cell.contentView.layer.shadowPath = shadowPath.CGPath;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CELL_SIZE, CELL_SIZE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.collectionView.frame.size.height - CELL_SIZE - 10, (collectionView.frame.size.width-CELL_SIZE)/2, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.saver.medias.count) return;
    
    selectedPageIndex = indexPath.row;
//    [self zoomAtIndexPath:indexPath];
    
    RecordViewController* parent = (RecordViewController*)self.parentViewController;
    
    [parent.swipablePager setSelectedViewController:[parent.swipablePager.viewControllers objectAtIndex:selectedPageIndex]];
}

- (void)collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    id media = [self.saver.medias objectAtIndex:atIndexPath.row];
    [self.saver.medias removeObjectAtIndex:atIndexPath.row];
    [self.saver.medias insertObject:media atIndex:toIndexPath.row];
    
    [self.recorder moveAudioFileWithIndex:atIndexPath.row atIndex:toIndexPath.row];
    
    RecordViewController* parent = (RecordViewController*)self.parentViewController;
    
    [parent moveViewControllerfromIndex:atIndexPath.row atIndex:toIndexPath.row];

    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView collectionViewLayout:(RAReorderableLayout *)layout didEndDraggingItemToIndexPath:(NSIndexPath *)indexPath {
    [self centerCollectionView];
    [UIView animateWithDuration:.2f animations:^{
//        [[(RecordViewController*)self.parentViewController currentPage].overlay setAlpha:0];
//        self.view.alpha = .5f;
        self.deleteButton.alpha = 0;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView collectionViewLayout:(RAReorderableLayout *)layout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:.2f animations:^{
//        [[(RecordViewController*)self.parentViewController currentPage].overlay setAlpha:.7f];
//        self.view.alpha = 1;
        self.deleteButton.alpha = 1;
    }];
}

#pragma mark - UIGestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint t = [gestureRecognizer translationInView:self.view];
    
    return t.y < -.5f || t.y > .5f;
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 1;
        CGPoint point = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:point];
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//        cell.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeRotation(0));
        cell.layer.zPosition = 0;
//        cell.alpha = INACTIVE_CELL_OPACITY;
    } completion:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [UIView animateWithDuration:.2f animations:^{
//        self.view.alpha = .5f;
    }];
}

#pragma mark - Navigation

- (void)zoomAtIndexPath:(NSIndexPath*)indexPath {
    RecordViewController* vc = (RecordViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record"];
    vc.currentIndex = selectedPageIndex;
    vc.organizeViewController = self;
    
    UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];

    cell.layer.zPosition = 1000;
    
    CGRect originalCellFrame = cell.frame;
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:20];
    CAShapeLayer* originalMask = (CAShapeLayer*)image.layer.mask;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:.2f] forKey:kCATransactionAnimationDuration];
    
    image.layer.mask = nil;
    
    [CATransaction commit];
    
    CGFloat ratio = (image.image.size.width / image.image.size.height);
    BOOL landscape = ratio > 1;
    
    __block CGFloat scale = 0;
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        scale = self.view.frame.size.height / cell.frame.size.height;
        
        if (landscape) {
            cell.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale * ratio, scale * ratio), CGAffineTransformMakeTranslation(150, 100));
        } else {
            cell.transform = CGAffineTransformMakeScale(scale+.1f, scale+.1f);
        }
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (landscape) {
                cell.transform = CGAffineTransformMakeScale(scale * ratio, scale * ratio);
            } else {
                cell.transform = CGAffineTransformMakeScale(scale, scale);
            }
        } completion:^(BOOL finished) {
            [self.navigationController pushViewController:vc animated:NO];
            
//            [self.view addSubview:vc.view];
//            [self addChildViewController:vc];
//            [vc didMoveToParentViewController:self];
            
            image.layer.mask = originalMask;
            cell.transform = CGAffineTransformMakeScale(1, 1);
            cell.frame = originalCellFrame;
        }];
    }];
}

#pragma mark - Helper

- (void)centerCollectionView {
    NSIndexPath *pathForCenterCell = [self.collectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.collectionView.bounds) - CELL_SIZE/2, CGRectGetMidY(self.collectionView.bounds))];
    [self.collectionView scrollToItemAtIndexPath:pathForCenterCell atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

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
    CGRect maskRect = expanded ? cell.bounds : CGRectMake(0, cell.frame.size.height/2 - CELL_SIZE/2, CELL_SIZE, CELL_SIZE);
    CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
    maskLayer.path = path;
    CGPathRelease(path);
    
    return maskLayer;
}

@end
