//
//  ShowCaseOverlay.m
//  Wireframe
//
//  Created by Leo on 17/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowCaseOverlay.h"

@implementation ShowCaseOverlay

- (void)addShowCaseElementWithFrame:(CGRect)frame labelText:(NSString *)text {
    [UIView animateWithDuration:.2f animations:^{
        self.backgroundColor = RgbColorAlpha(0, 0, 0, 0.9f);
    }];
    
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"GTWalsheim-Regular" size:18];
    [self addSubview:label];
    
    [self setNeedsDisplay];
    
    [self.superview bringSubviewToFront:self];
}

@end
