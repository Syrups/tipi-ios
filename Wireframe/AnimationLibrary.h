//
//  AnimationLibrary.h
//  Wireframe
//
//  Created by Leo on 16/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AnimationLibraryBottomSpaceConstraint,
    AnimationLibraryTopSpaceConstraint,
    AnimationLibraryVerticalAlignConstraint,
} AnimationLibraryConstraintType;

@interface AnimationLibrary : NSObject

+ (void)animateBouncingView:(UIView*)view;
+ (void)animateBouncingView:(UIView *)view usingConstraint:(NSLayoutConstraint*)constraint ofType:(AnimationLibraryConstraintType)type relativeToSuperview:(UIView*)superview inverted:(BOOL)inverted;

@end
