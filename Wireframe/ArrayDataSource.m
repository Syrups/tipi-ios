//
//  RoomsDataSource.m
//  Wireframe
//
//  Created by Leo on 22/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ArrayDataSource.h"

@implementation ArrayDataSource

- (id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(void (^)(UICollectionViewCell *, id))configureBlock {
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return [self.items objectAtIndex:indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = nil;
    
    id item = [self.items objectAtIndex:indexPath.row];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    
    return cell;
}

@end
