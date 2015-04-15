//
//  SRRecordButton.h
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRRecordButton : UIView

@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) UIColor* fillColor;
@property CGFloat duration;
@property CGFloat currentTime;

- (void)appear;
- (void)close;
- (void)start;
- (void)pause;
- (void)reset;

@end
