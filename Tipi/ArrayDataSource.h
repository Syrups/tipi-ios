//
//  RoomsDataSource.h
//  Wireframe
//
//  Created by Leo on 22/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrayDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray* items;

- (id)initWithItems:(NSArray*)items cellIdentifier:(NSString*)identifier configureCellBlock:(void(^)(UICollectionViewCell*, id))configureBlock;

@end
