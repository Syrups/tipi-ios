//
//  RoomPickerViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RoomPickerViewController.h"

@interface RoomPickerViewController ()

@end

@implementation RoomPickerViewController {
    NSMutableArray* selectedIndexes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedIndexes = [NSMutableArray array];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backToStart:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    for (UIView* v in cell.contentView.subviews) {
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (![selectedIndexes containsObject:indexPath]) {
        [selectedIndexes addObject:indexPath];
        
        for (UIView* v in cell.contentView.subviews) {
            v.backgroundColor = [UIColor blackColor];
            v.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        
        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
        name.textColor = [UIColor whiteColor];
        
    } else {
        [selectedIndexes removeObject:indexPath];
        for (UIView* v in cell.contentView.subviews) {
            v.backgroundColor = [UIColor whiteColor];
            v.layer.borderColor = [UIColor blackColor].CGColor;
        }
        
        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
        name.textColor = [UIColor blackColor];
    }
}

@end
