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
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    //Top curve
    float half = view.frame.size.height * 0.5f;
    [path moveToPoint:CGPointMake(view.frame.size.width, half - 100)];
    
    float xpc1 = view.frame.size.width - 20;
    float yTopHalf = half-50;
    
    [path addCurveToPoint:CGPointMake(xpc1, yTopHalf)
            controlPoint1:CGPointMake(xpc1 + 15, half - 70)
            controlPoint2:CGPointMake(xpc1 , yTopHalf)];
    
    //Bump
    float xcp1B = view.frame.size.width - 20;
    float bumpX = xcp1B - 25;
    [path addCurveToPoint:CGPointMake(xcp1B, half + 50)
            controlPoint1:CGPointMake(bumpX, half - 10)
            controlPoint2:CGPointMake(bumpX, half + 10)];
    
    /*[path addQuadCurveToPoint:CGPointMake(view.frame.size.width - 20, half + 50)
                 controlPoint:CGPointMake(view.frame.size.width - 50, half)];*/
    
    //Bottom curve
    float yBotHalf = half+50;
    [path addCurveToPoint:CGPointMake(view.frame.size.width, half + 100)
            controlPoint1:CGPointMake(xpc1, yBotHalf)
            controlPoint2:CGPointMake(xpc1 + 15, half + 70)];
    
    /*[path addQuadCurveToPoint:CGPointMake(view.frame.size.width , half + 100)
                 controlPoint:CGPointMake(view.frame.size.width - 100, half)];*/
    //[path addQuadCurveToPoint:CGPointMake(self.view.frame.size.width, 2*self.view.frame.size.height) controlPoint:CGPointMake(-self.view.frame.size.width*2, self.view.frame.size.height/2)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor colorWithRed:61 green:22 blue:20 alpha:1] CGColor];
    //[[UIColor clearColor] CGColor];
    
    [view.layer addSublayer:shapeLayer];
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
    
    //Top curve
    float half = frame.size.height * 0.5f;
    [path moveToPoint:CGPointMake(frame.size.width, half - 100)];
    
    float xpc1 = frame.size.width - 20;
    float yTopHalf = half-50;
    
    [path addCurveToPoint:CGPointMake(xpc1, yTopHalf)
            controlPoint1:CGPointMake(xpc1 + 15, half - 70)
            controlPoint2:CGPointMake(xpc1 , yTopHalf)];
    //Bump
    float xcp1B = frame.size.width - 20;
    float bumpX = xcp1B - 25;
    [path addCurveToPoint:CGPointMake(xcp1B, half + 50)
            controlPoint1:CGPointMake(bumpX, half - 10)
            controlPoint2:CGPointMake(bumpX, half + 10)];
    //Bottom curve
    float yBotHalf = half+50;
    [path addCurveToPoint:CGPointMake(frame.size.width, half + 100)
            controlPoint1:CGPointMake(xpc1, yBotHalf)
            controlPoint2:CGPointMake(xpc1 + 15, half + 70)];

    return path;
}


/*
+ (void)expandOnLayer:(CAShapeLayer*)shapeLayer WithCompletion:(void (^)())completionBlock {
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:completionBlock];
    
    
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.3f;
    morph.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.45f :.14f :.84f :.48f];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayerExpanded];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"expand"];
    
    [shapeLayer.modelLayer setPath:to];
    
    [CATransaction commit];
}*/

/*
+ (void)animateUpdate:(CAShapeLayer*)shapeLayer {
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.3f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayer];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"morphing"];
    
    [shapeLayer.modelLayer setPath:to];
}*/

/*
+ (CGPathRef)pathForLayerExpanded {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(self.frame.size.width, -self.frame.size.height)];
    
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width, 2*self.frame.size.height) controlPoint:CGPointMake(-self.frame.size.width*2, self.frame.size.height/2)];
    
    
    return path.CGPath;
    
}*/

@end
