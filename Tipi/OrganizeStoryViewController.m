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
    NSString* oldHelpText;
    NSUInteger selectedPageIndex;
    CGFloat lastOffset;
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
    
    pendingCellToRemoveIndex = -1;
    
    self.collectionView.collectionViewLayout = layout;
    
    self.saver = [StoryWIPSaver sharedSaver];
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    
    // We load the first XX images in full resolution
    // so they can display immediately on collection view,
    // while we load all the others in the background thread.
    
    [self.saver.medias enumerateObjectsUsingBlock:^(NSMutableDictionary* media, NSUInteger idx, BOOL *stop) {
        
        if (idx < 4) {
            ALAsset* asset = (ALAsset*)[media objectForKey:@"asset"];
            UIImage* full = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            [media setObject:full forKey:@"full"];
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
    
//    [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(animateCoachmark:) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.replayButton.alpha = 1;
    
    if ([self.recorder isComplete] && ![self.recorder isEmpty]) {
        self.replayButton.hidden = YES;
        self.finishButton.hidden = NO;
    } else if ([self.recorder isEmpty]) {
        self.replayButton.hidden = YES;
    } else {
        self.replayButton.hidden = NO;
        self.finishButton.hidden = YES;
    }
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
                cell.transform = CGAffineTransformMakeTranslation(0, -120);
                self.overlay.alpha = .5f;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.4f relativeDuration:.6f animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, -80);
            }];
            
        } completion:nil];
    } else if (t.y > 2) {
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pendingCellToRemoveIndex inSection:0]];
        
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            UIButton *delete = (UIButton*)[cell.contentView viewWithTag:30];
            delete.alpha = 0;
            delete.enabled = NO;
            cell.transform = CGAffineTransformIdentity;
            self.overlay.alpha = 0;
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
    image.layer.mask = [self maskForCell:cell expanded:NO];
    
    [image setImage:[media objectForKey:@"full"]];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    
    cell.contentView.tag = indexPath.row;
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRemoveState:)];
    pan.delegate = self;
    [cell.contentView addGestureRecognizer:pan];
    
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
    return UIEdgeInsetsMake(110, (collectionView.frame.size.width-CELL_SIZE)/2, 120, collectionView.frame.size.width/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.saver.medias.count) return;
    
    selectedPageIndex = indexPath.row;
    [self zoomAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:atIndexPath];
    
    id media = [self.saver.medias objectAtIndex:atIndexPath.row];
    [self.saver.medias removeObjectAtIndex:atIndexPath.row];
    [self.saver.medias insertObject:media atIndex:toIndexPath.row];
    
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%ld sur %ld", (unsigned long)[self.saver.medias indexOfObject:media], (unsigned long)self.saver.medias.count];
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView collectionViewLayout:(RAReorderableLayout *)layout didEndDraggingItemToIndexPath:(NSIndexPath *)indexPath {
    [self centerCollectionView];
}


- (BOOL)collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath canMoveToIndexPath:(NSIndexPath *)canMoveToIndexPath {
    CGPoint point = CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    NSIndexPath* visibleIndexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    return visibleIndexPath.row == atIndexPath.row;
}

#pragma mark - UIGestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint t = [gestureRecognizer translationInView:self.view];
    
    return t.y < -.5f || t.y > .5f;
}

#pragma mark - UIScrollView

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
        
        self.replayButton.alpha = 0;
        
        self.topControlsYConstraint.constant = -100;
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

- (IBAction)openDonePopin:(id)sender {
    DoneStoryViewController* done = (DoneStoryViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"DoneStory"];
    
    [self addChildViewController:done];
    done.view.frame = self.view.frame;
    done.view.alpha = 0;
    [self.view addSubview:done.view];
    [done didMoveToParentViewController:self];
    
    self.donePopin = done;
    
    [UIView animateWithDuration:.3f animations:^{
        done.view.alpha = 1;
    }];
}

- (void)openNameStoryPopin {
    NameStoryViewController* done = (NameStoryViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NameStory"];
    
    [self addChildViewController:done];
    done.view.frame = self.view.frame;
    done.view.alpha = 0;
    [self.view addSubview:done.view];
    [done didMoveToParentViewController:self];
    
    [self.donePopin.view removeFromSuperview];
    [self.donePopin removeFromParentViewController];
    
    self.namePopin = done;
    
    [UIView animateWithDuration:.3f animations:^{
        done.view.alpha = 1;
    }];
}

#pragma mark - Helper

- (void)centerCollectionView {
    NSIndexPath *pathForCenterCell = [self.collectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.collectionView.bounds) - CELL_SIZE/2, CGRectGetMidY(self.collectionView.bounds))];
    [self.collectionView scrollToItemAtIndexPath:pathForCenterCell atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    

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

#pragma mark - Coachmark

- (IBAction)animateCoachmark:(id)sender {
    [CoachmarkManager launchCoachmarkAnimationForOrganizerController:self withCompletion:^{
        
    }];
}

@end
