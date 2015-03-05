//
//  MediaPickerViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "MediaPickerViewController.h"
#import "PKCollectionViewStickyHeaderFlowLayout.h"

@interface MediaPickerViewController ()

@end

@implementation MediaPickerViewController {
    NSMutableArray* selectedIndexes;
}

- (void)viewDidLoad {
    selectedIndexes = [NSMutableArray array];
    
//    self.mediaCollectionView.collectionViewLayout = [[PKCollectionViewStickyHeaderFlowLayout alloc] init];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Autorisation" message:@"Cette application souhaite accéder à vos photos" delegate:nil cancelButtonTitle:@"Annuler" otherButtonTitles:@"Autoriser", nil];
    
    [alert show];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
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
    } else {
        [selectedIndexes removeObject:indexPath];
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    
    self.selectedCount.text = [NSString stringWithFormat:@"%ld selected", selectedIndexes.count];
}



@end
