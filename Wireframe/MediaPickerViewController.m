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
    
    NSMutableArray* assetGroups = [NSMutableArray array];
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    NSUInteger types = ALAssetsGroupAll;
    [library enumerateGroupsWithTypes:types usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [assetGroups addObject:group];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                    
                    [library assetForURL:url
                             resultBlock:^(ALAsset *asset) { //Your line
                                 ALAssetRepresentation* rep = [asset defaultRepresentation];
                                 
                                 UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
                                 UIImage* fullImage = [UIImage imageWithCGImage:[rep fullScreenImage]];
                                 [self.medias addObject:@{
                                        @"image": image,
                                        @"full": fullImage,
                                        @"date": [result valueForProperty:ALAssetPropertyDate]
                                  }];
                                 
                                 if (index+1 == group.numberOfAssets) {
                                     [self.mediaCollectionView reloadData];
                                 }
                             }
                            failureBlock:^(NSError *error){
                                NSLog(@"test:Fail");
                            }];
                }
                
                
            }];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.medias.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:10];
    NSDictionary* media = [self.medias objectAtIndex:indexPath.row];
    [image setImage:[media objectForKey:@"image"]];
    
    
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
