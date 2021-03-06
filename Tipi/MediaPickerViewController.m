//
//  MediaPickerViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MediaPickerViewController.h"
#import "PKCollectionViewStickyHeaderFlowLayout.h"
#import "MediaCell.h"
#import "HelpModalViewController.h"
#import "TPLoader.h"
#import "ImageUtils.h"
#import "AnimationLibrary.h"
#import <UIView+MTAnimation.h>

@implementation MediaPickerViewController {
    BOOL loading;
    NSMutableArray* unorderedMedias;
    CAGradientLayer* maskLayer;
    TPLoader* loader;
    UIImageView* preview;
    BOOL firstLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndexes = [NSMutableArray array];
    self.saver = [StoryWIPSaver sharedSaver];
    
    self.library = [[MediaLibrary alloc] init];
    self.library.delegate = self;
    
    self.medias = [self.library cachedMedias];
    unorderedMedias = [NSMutableArray array];
    
    self.topControlsYConstraint.constant = -100;
    self.continueButtonYConstraint.constant = -200;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.4f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.topControlsYConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self.library fetchMediasFromLibrary];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    if (self.selectedIndexes.count > 0) {
        self.continueButtonYConstraint.constant = 42;
    }
    
    if (!maskLayer) {
//        maskLayer = [CAGradientLayer layer];
//        
//        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
//        CGColorRef innerColor = RgbColorAlpha(41, 57, 92, 1).CGColor;
//        
//        maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor, (__bridge id)innerColor, nil];
//        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.1],
//                               [NSNumber numberWithFloat:0.2], nil];
//        
//        maskLayer.bounds = CGRectMake(0, 0,
//                                      self.mediaCollectionView.frame.size.width,
//                                      self.mediaCollectionView.frame.size.height);
//        maskLayer.anchorPoint = CGPointZero;
//        
//        self.mediaCollectionView.layer.mask = maskLayer;
    }
}

- (IBAction)openHelp:(id)sender {
    HelpModalViewController* helpVc = (HelpModalViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpModal"];
    
    [self addChildViewController:helpVc];
    helpVc.view.frame = self.view.frame;
    [self.view addSubview:helpVc.view];
    [helpVc didMoveToParentViewController:self];
}

#pragma mark - MediaLibrary

- (void)mediaLibrary:(MediaLibrary *)library successfullyFetchedMedias:(NSArray *)medias {

    // reverse array
    NSMutableArray *reversed = [NSMutableArray arrayWithCapacity:[medias count]];
    NSEnumerator *enumerator = [medias reverseObjectEnumerator];
    for (id element in enumerator) {
        [reversed addObject:element];
    }
    
    self.medias = reversed;
    
    loading = NO;

    [self.mediaCollectionView reloadData];

    [loader removeFromSuperview];
}

#pragma mark - UIGestureRecognizer

- (void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            NSUInteger index = gestureRecognizer.view.tag;
            
            if (preview != nil) return;
            
            preview = [[UIImageView alloc] initWithFrame:self.view.frame];
            NSDictionary* media = [self.medias objectAtIndex:index];
            ALAsset* asset = (ALAsset*)[media objectForKey:@"asset"];
            UIImage* full = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            preview.image = full;
            preview.alpha = .8f;
            preview.contentMode = UIViewContentModeScaleAspectFill;
            
            [self.view addSubview:preview];
            break;
        }
        case UIGestureRecognizerStateEnded:
            [preview removeFromSuperview];
            preview = nil;
            
        default:
            break;
    }
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.medias.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:10];
    NSMutableDictionary* media = [self.medias objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[MediaCell alloc] initWithMedia:media];
    }
    
    [image setImage:[media objectForKey:@"image"]];
    
    int endY = cell.frame.origin.y;
    
    if (!firstLoad && indexPath.row < 8) { // not animated yet, we only animate the first cells
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + 300, cell.frame.size.width, cell.frame.size.height);
        
        [UIView mt_animateWithViews:@[cell] duration:.5f delay:indexPath.row * .05f timingFunction:kMTEaseOutBack animations:^{
            cell.frame = CGRectMake(cell.frame.origin.x, endY, cell.frame.size.width, cell.frame.size.height);
        } completion:^{
            firstLoad = YES;
        }];
    }

    UIView* check = (UIView*)[cell.contentView viewWithTag:30];
    
//    if ([[media objectForKey:@"type"] isEqual:ALAssetTypeVideo]) {
//        [cell launchVideoPreviewWithUrl:[media objectForKey:@"url"]];
//    } else {
//        [cell.playerLayer removeFromSuperlayer];
//    }
    
    if ([self.saver.medias containsObject:media]) {
        check.alpha = 1;
    } else {
        check.alpha = 0;
    }
        
//    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(60, 10, 100, 10);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat s = self.mediaCollectionView.frame.size.width/2.3f;
    
    return CGSizeMake(s, s);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIView* check = [cell.contentView viewWithTag:30];
    
    if (![self.selectedIndexes containsObject:indexPath]) {
        ((UIView*)check.subviews[0]).transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.3f animations:^{
            check.alpha = 1;
            ((UIView*)check.subviews[0]).transform = CGAffineTransformMakeScale(1, 1);
        }];
        [self.selectedIndexes addObject:indexPath];
        [self.saver.medias addObject:[self.medias objectAtIndex:indexPath.row]];
        
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            check.alpha = 0;
        }];
        [self.selectedIndexes removeObject:indexPath];
        [self.saver.medias removeObject:[self.medias objectAtIndex:indexPath.row]];
    }
    
    [UIView animateWithDuration:.3f animations:^{
        if (self.selectedIndexes.count > 0) {
            self.continueButton.enabled = YES;
            self.continueButtonYConstraint.constant = 42;
            [self.continueButton layoutIfNeeded];
        } else {
            self.continueButton.enabled = NO;
            self.continueButtonYConstraint.constant = -200;
            [self.continueButton layoutIfNeeded];
        }
    }];
    
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}


@end
