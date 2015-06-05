//
//  SHPathLibrary.h
//  Wireframe
//
//  Created by Glenn Sonna on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface SHPathLibrary : NSObject
+ (void) addRightCurveBezierPathToView: (UIView *) view inverted:(BOOL)inverted;
+ (void) addRightCurveBezierPathToView: (UIView *) view withColor:(UIColor*)color inverted:(BOOL)inverted;
+ (void) addBackgroundPathForstoriesToView: (UIView *) view;

+ (UIBezierPath *) swippedRightCurvyBezierPathForRect: (CGRect) frame inverted:(BOOL)inverted;
+ (UIBezierPath *) swipableRightCurvyBezierPathForRect: (CGRect) frame inverted:(BOOL)inverted;

+ (UIBezierPath *) pathForHomeBubbleInRect:(CGRect)rect open:(BOOL)open;
+ (UIBezierPath *) pathForHomeBubbleStickyToTopInRect:(CGRect)rect bumpDelta:(NSInteger)bumpDelta;

+ (UIBezierPath *) pathForTransitionBeetweenStoriesAndAdmin: (CGRect) rect segueBack:(BOOL) back withFinalPath:(BOOL) finalPath;
+ (UIBezierPath *) pathForTransitionToAdminFromStories: (CGRect) rect withFinalPath:(BOOL) finalPath;
+ (UIBezierPath *) pathForTransitionFromAdminToStories: (CGRect) rect withFinalPath:(BOOL) finalPath;

+ (UIBezierPath *) pathForTransitionBeetweenRoomsAndStories: (CGRect) rect segueBack:(BOOL) back withFinalPath:(BOOL) finalPath;

+ (UIBezierPath *) pathForProfileView:(UIView*)view open: (BOOL)open bumpDelta:(CGFloat)delta;

@end
