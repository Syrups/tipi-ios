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

@implementation MediaPickerViewController {
    NSMutableArray* selectedIndexes;
    NSUInteger currentOffset;
    BOOL loading;
    NSMutableArray* unorderedMedias;
}

- (void)viewDidLoad {
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:10];
    NSDictionary* media = [self.medias objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
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

    
    UIView* vidIcon = (UIView*)[cell.contentView viewWithTag:20];
    UIView* check = (UIView*)[cell.contentView viewWithTag:30];
    
    if ([[media objectForKey:@"type"] isEqual:ALAssetTypeVideo]) {
        vidIcon.hidden = NO;
    } else {
        vidIcon.hidden = YES;
    }
    
    if ([selectedIndexes containsObject:indexPath]) {
        check.alpha = 1;
    } else {
        check.alpha = 0;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat s = self.mediaCollectionView.frame.size.width/2 - 15;
    
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
    
    if (![selectedIndexes containsObject:indexPath]) {
        ((UIView*)check.subviews[0]).transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.3f animations:^{
            check.alpha = 1;
            ((UIView*)check.subviews[0]).transform = CGAffineTransformMakeScale(1, 1);
        }];
        [selectedIndexes addObject:indexPath];
        [self.saver.medias addObject:[self.medias objectAtIndex:indexPath.row]];
        [self.wave grow];
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
    NSArray* visibleIndexPaths = [self.mediaCollectionView indexPathsForVisibleItems];
    
    NSLog(@"%d / %d", self.medias.count, self.library.totalMediasCount);
    
    if ([visibleIndexPaths containsObject:[NSIndexPath indexPathForItem:self.medias.count-1 inSection:0]] && !loading && self.medias.count < self.library.totalMediasCount) {
        loading = YES;
//        self.activityIndicator.hidden = NO;
        [self.library fetchMediasFromLibraryFrom:currentOffset to:currentOffset+10];
    }
}

@end
