//
//  Timeline.h
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Timeline : UIView

- (instancetype)initWithFrame:(CGRect)frame mediaCount:(NSUInteger)mediaCount;
- (void)updateWithIndex:(NSUInteger)index;

@end
