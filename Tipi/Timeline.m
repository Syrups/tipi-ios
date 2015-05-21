//
//  Timeline.m
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "Timeline.h"

@implementation Timeline {
    NSMutableArray* subviews;
}

- (instancetype)initWithFrame:(CGRect)frame mediaCount:(NSUInteger)mediaCount
{
    self = [super initWithFrame:frame];
    subviews = [NSMutableArray array];
    
    if (self) {
        for (int i = 0 ; i < mediaCount ; ++i) {
            CGFloat x = (frame.size.width / mediaCount) * i;
            CGFloat w = frame.size.width / mediaCount;
            UIView* v = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, frame.size.height)];
            
            v.backgroundColor = RgbColorAlpha(255, 255, 255, .5f);
            v.alpha = i == 0 ? .5f : .2f;
            
            [subviews addObject:v];
            
            [self addSubview:v];
        }
    }
    return self;
}

- (void)updateWithIndex:(NSUInteger)index {
    [UIView animateWithDuration:.3f animations:^{
        [subviews enumerateObjectsUsingBlock:^(UIView* v, NSUInteger idx, BOOL *stop) {
            v.alpha = .2f;
            
            if (idx == index) v.alpha = .5f;
        }];
    }];
}

@end
