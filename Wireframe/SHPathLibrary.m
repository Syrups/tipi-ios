//
//  SHPathLibrary.m
//  Wireframe
//
//  Created by Glenn Sonna on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SHPathLibrary.h"


@implementation SHPathLibrary


+ (void) addRightCurveBezierPathToView: (UIView *) view {
    UIBezierPath* path = [SHPathLibrary swipableRightCurvyBezierPathForRect:view.frame];
    
    UIColor *color = [UIColor colorWithRed:46/255.0  green:13/255.0 blue:14/255.0 alpha:1];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [color CGColor];
    
    [view.layer addSublayer:shapeLayer];
}

+ (UIBezierPath *) swipableRightCurvyBezierPathForView: (UIView *) view inLayer :(CAShapeLayer*)layer{
    UIBezierPath* path = [SHPathLibrary swipableRightCurvyBezierPathForRect:view.frame];
    
    [view.layer addSublayer:layer];
    return path;
}

+ (UIBezierPath *) swipableRightCurvyBezierPathForView: (UIView *) view {
    UIBezierPath* path = [SHPathLibrary swipableRightCurvyBezierPathForRect:view.frame];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor colorWithRed:61 green:22 blue:20 alpha:1] CGColor];

    [view.layer addSublayer:shapeLayer];
    
    return path;
}

+ (UIBezierPath *) swipableRightCurvyBezierPathForRect: (CGRect ) frame {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    float width = CGRectGetWidth(frame);
    
    //Top curve
    float half = CGRectGetMidY(frame);
    [path moveToPoint:CGPointMake(width, half - 100)];
    
    float xpc1 = width - 20;
    float yTopHalf = half - 50;
    
    [path addCurveToPoint:CGPointMake(xpc1, yTopHalf)
            controlPoint1:CGPointMake(xpc1 + 15, half - 70)
            controlPoint2:CGPointMake(xpc1 , yTopHalf)];
    //Bump
    float xcp1B = width - 20;
    float bumpX = xcp1B - 25;
    [path addCurveToPoint:CGPointMake(xcp1B, half + 50)
            controlPoint1:CGPointMake(bumpX, half - 10)
            controlPoint2:CGPointMake(bumpX, half + 10)];
    //Bottom curve
    float yBotHalf = half+50;
    [path addCurveToPoint:CGPointMake(width, half + 100)
            controlPoint1:CGPointMake(xpc1, yBotHalf)
            controlPoint2:CGPointMake(xpc1 + 15, half + 70)];

    return path;
}

+ (UIBezierPath *) swippedRightCurvyBezierPathForRect: (CGRect ) frame {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    float width = CGRectGetWidth(frame);
    float theLesserX = CGRectGetWidth(frame) * 2;
    float theLesserY = CGRectGetHeight(frame);
    //Top curve
    float half = CGRectGetMidY(frame);
    [path moveToPoint:CGPointMake(width, half - 100 - theLesserY)];
    
    float xpc1 = width - 20;
    float yTopHalf = half-50;
    
    //[path moveToPoint:CGPointMake(xpc1 , yTopHalf)];
    [path addCurveToPoint:CGPointMake(xpc1 - theLesserX, yTopHalf)
            controlPoint1:CGPointMake(xpc1 + 15, half - 70 - theLesserY)
            controlPoint2:CGPointMake(xpc1 - theLesserX, yTopHalf)];
    //Bump
    float xcp1B = width - 20;
    float bumpX = xcp1B - 25;
    [path addCurveToPoint:CGPointMake(xcp1B - theLesserX, half + 50)
            controlPoint1:CGPointMake(bumpX - theLesserX, half - 10)
            controlPoint2:CGPointMake(bumpX - theLesserX, half + 10)];
    //Bottom curve
    float yBotHalf = half+50;
    [path addCurveToPoint:CGPointMake(width , half + 100 + theLesserY)
            controlPoint1:CGPointMake(xpc1 - theLesserX, yBotHalf)
            controlPoint2:CGPointMake(xpc1 + 15, half + 70 + theLesserY)];
    
    return path;
}

@end
