//
//  OrganizeStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "OrganizeStoryViewController.h"

#define CELL_SIZE 180

@interface OrganizeStoryViewController ()

@end

@implementation OrganizeStoryViewController {
    NSString* oldHelpText;
    NSMutableArray* medias;
}

- (void)viewDidLoad {
    LXReorderableCollectionViewFlowLayout* layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.longPressGestureRecognizer.minimumPressDuration = 0;
    layout.scrollingSpeed = 400;
    
    self.collectionView.collectionViewLayout = layout;
    
    medias = @[@"toto", @"tata", @"titi", @"toto", @"tata", @"titi", @"toto", @"tata", @"titi"].mutableCopy;
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
    return medias.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%ld sur %ld", (unsigned long)indexPath.row+1, (unsigned long)medias.count];

    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CELL_SIZE, CELL_SIZE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (collectionView.frame.size.width-CELL_SIZE)/4;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, (collectionView.frame.size.width-CELL_SIZE)/2, 0, (collectionView.frame.size.width-CELL_SIZE)/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ToRecord" sender:nil];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:fromIndexPath];
    
    id media = [medias objectAtIndex:fromIndexPath.row];
    [medias removeObjectAtIndex:fromIndexPath.row];
    [medias insertObject:media atIndex:toIndexPath.row];
    
    
    UILabel* label = (UILabel*)[cell.contentView viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%ld sur %ld", (unsigned long)[medias indexOfObject:media], (unsigned long)medias.count];
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    oldHelpText = self.helpLabel.text;
    self.helpLabel.text = @"pull to remove";
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    self.helpLabel.text = oldHelpText;
}


@end
