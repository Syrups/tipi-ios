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

+ (UIBezierPath *) swippedRightCurvyBezierPathForRect: (CGRect) frame;
+ (UIBezierPath *) swippedRightCurvyBezierPathForRect: (CGRect) frame inverted:(BOOL)inverted;
+ (UIBezierPath *) swipableRightCurvyBezierPathForRect: (CGRect) frame inverted:(BOOL)inverted;

@end
