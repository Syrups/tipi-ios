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

@interface MediaPickerViewController ()

@end

@implementation MediaPickerViewController {
    NSMutableArray* selectedIndexes;
}

- (void)viewDidLoad {
    selectedIndexes = [NSMutableArray array];
    self.medias = [NSMutableArray array];
    self.saver = [StoryWIPSaver sharedSaver];
    
    self.activityIndicator.hidden = NO;
    
    MediaLibrary* library = [[MediaLibrary alloc] init];
    library.delegate = self;
    
    [library fetchMediasFromLibrary];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MediaLibrary

- (void)mediaLibrary:(MediaLibrary *)library successfullyFetchedMedias:(NSArray *)medias {
    self.activityIndicator.hidden = YES;
    self.medias = medias.mutableCopy;
    [self.mediaCollectionView reloadData];
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
    
    UIView* vidIcon = (UIView*)[cell.contentView viewWithTag:20];
    
    if ([[media objectForKey:@"type"] isEqual:ALAssetTypeVideo]) {
        vidIcon.hidden = NO;
    } else {
        vidIcon.hidden = YES;
    }
    
    if (![selectedIndexes containsObject:indexPath]) {
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    } else {
        cell.contentView.backgroundColor = [UIColor blackColor];
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
    if (![selectedIndexes containsObject:indexPath]) {
        cell.contentView.backgroundColor = [UIColor blackColor];
        [selectedIndexes addObject:indexPath];
        [self.saver.medias addObject:[self.medias objectAtIndex:indexPath.row]];
    } else {
        [selectedIndexes removeObject:indexPath];
        [self.saver.medias removeObject:[self.medias objectAtIndex:indexPath.row]];
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    
    self.selectedCount.text = [NSString stringWithFormat:@"%ld selected", selectedIndexes.count];
}



@end
