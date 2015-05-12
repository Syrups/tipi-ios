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

static float const fadePercentage = 0.2;

@implementation MediaPickerViewController {
    NSMutableArray* selectedIndexes;
    NSUInteger currentOffset;
    BOOL loading;
    NSMutableArray* unorderedMedias;
    CAGradientLayer* maskLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndexes = [NSMutableArray array];
    self.saver = [StoryWIPSaver sharedSaver];
    
    self.activityIndicator.hidden = NO;
    
    self.library = [[MediaLibrary alloc] init];
    self.library.delegate = self;
//    [self.library preload];
    
    self.medias = [self.library cachedMedias];
    unorderedMedias = [NSMutableArray array];
    
    currentOffset = 0;
    [self.library fetchMediasFromLibraryFrom:currentOffset to:currentOffset + kMediaPickerMediaLimit];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!maskLayer) {
        maskLayer = [CAGradientLayer layer];
        
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
        CGColorRef innerColor = RgbColorAlpha(41, 57, 92, 1).CGColor;
        
        maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor, (__bridge id)innerColor, nil];
        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.1],
                               [NSNumber numberWithFloat:0.3], nil];
        
        maskLayer.bounds = CGRectMake(0, 0,
                                      self.mediaCollectionView.frame.size.width,
                                      self.mediaCollectionView.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        
        self.mediaCollectionView.layer.mask = maskLayer;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openHelp:(id)sender {
    HelpModalViewController* helpVc = (HelpModalViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpModal"];
    
    [self addChildViewController:helpVc];
    helpVc.view.frame = self.view.frame;
    [self.view addSubview:helpVc.view];
    [helpVc didMoveToParentViewController:self];
}

#pragma mark - MediaLibrary

- (void)mediaLibrary:(MediaLibrary *)library successfullyFetchedMedias:(NSArray *)medias from:(NSUInteger)start to:(NSUInteger)limit {
    
    // reverse array
    NSMutableArray *reversed = [NSMutableArray arrayWithCapacity:[medias count]];
    NSEnumerator *enumerator = [medias reverseObjectEnumerator];
    for (id element in enumerator) {
        [reversed addObject:element];
    }

    self.activityIndicator.hidden = YES;
    loading = NO;
    [self.medias addObjectsFromArray:reversed];
    
    [self.mediaCollectionView reloadData];
    currentOffset += kMediaPickerMediaLimit + 1;

    
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
    
    if (cell.tag == 0) {
//        image.transform = CGAffineTransformMakeScale(0, 0);
        image.alpha = 0;
        [UIView animateWithDuration:0.2f delay:indexPath.row*0.03f options:UIViewAnimationOptionCurveEaseIn animations:^{
//            image.transform = CGAffineTransformMakeScale(1, 1);
            image.alpha = 1;
        } completion:nil];
        cell.tag = 1;
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
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(150, 10, 100, 10);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat s = self.mediaCollectionView.frame.size.width/2.5f;
    
    return CGSizeMake(s, s);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView* reusable = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MediaHeader" forIndexPath:indexPath];
        reusable = header;
        
    }
    
    return reusable;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIView* check = [cell.contentView viewWithTag:30];
    NSDictionary* media = [self.medias objectAtIndex:indexPath.row];
    
    if (![selectedIndexes containsObject:indexPath]) {
        ((UIView*)check.subviews[0]).transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.3f animations:^{
            check.alpha = 1;
            ((UIView*)check.subviews[0]).transform = CGAffineTransformMakeScale(1, 1);
        }];
        [selectedIndexes addObject:indexPath];
        [self.saver.medias addObject:[self.medias objectAtIndex:indexPath.row]];
        [self.wave grow];
        
        [self.wave updateImage:[media objectForKey:@"image"]];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            check.alpha = 0;
        }];
        [selectedIndexes removeObject:indexPath];
        [self.saver.medias removeObject:[self.medias objectAtIndex:indexPath.row]];
        [self.wave ungrow];
    }
    
    if (selectedIndexes.count > 0) {
        self.continueButton.enabled = YES;
        self.continueButton.alpha = 1;
    } else {
        self.continueButton.enabled = NO;
        self.continueButton.alpha = 0.3f;
    }
    
    self.selectedCount.text = [NSString stringWithFormat:@"%ld médias sélectionnés", (unsigned long)selectedIndexes.count];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
    
    NSArray* visibleIndexPaths = [self.mediaCollectionView indexPathsForVisibleItems];
    
    NSLog(@"%d / %d", self.medias.count, self.library.totalMediasCount);
    
    if ([visibleIndexPaths containsObject:[NSIndexPath indexPathForItem:self.medias.count-1 inSection:0]] && !loading && self.medias.count < self.library.totalMediasCount) {
        loading = YES;
//        self.activityIndicator.hidden = NO;
        [self.library fetchMediasFromLibraryFrom:currentOffset to:currentOffset+10];
    }
    
}

@end
