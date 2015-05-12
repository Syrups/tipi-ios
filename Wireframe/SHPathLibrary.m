//
//  SHPathLibrary.m
//  Wireframe
//
//  Created by Glenn Sonna on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SHPathLibrary.h"


@implementation SHPathLibrary

+ (void) addBackgroundPathForstoriesToView: (UIView *) mainView{
    
    mainView.backgroundColor = [UIColor colorWithRed:178/255.0  green:47/255.0 blue:43/255.0 alpha:1];
    
    UIView* view = [[UIView alloc]initWithFrame:mainView.frame];
    [mainView insertSubview:view atIndex:0];
    
    float width = CGRectGetWidth(view.frame);
    float height = CGRectGetHeight(view.frame);
    
    float midX = CGRectGetMidX(view.frame);
    float midY = CGRectGetMidY(view.frame);
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, midY)];
    [path addQuadCurveToPoint: CGPointMake(width, midY) controlPoint: CGPointMake(midX, midY + 120)];
    [path addLineToPoint:CGPointMake(width, height)]; //
    [path addLineToPoint:CGPointMake(0, height)]; // <--
    [path addLineToPoint:CGPointMake(0, midY)]; // __^
    
    //UIColor *pathColor = color ? color : [UIColor colorWithRed:46/255.0  green:13/255.0 blue:14/255.0 alpha:1];
    
    UIColor *pathColor = [UIColor colorWithRed:163/255.0  green:41/255.0 blue:38/255.0 alpha:1];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [pathColor CGColor];
    
    [view.layer addSublayer:shapeLayer];
}


+ (void) addRightCurveBezierPathToView: (UIView *) view withColor:(UIColor*)color inverted:(BOOL)inverted{
    UIBezierPath* path = [SHPathLibrary swipableRightCurvyBezierPathForRect:view.frame inverted:inverted];
    
    UIColor *pathColor = color ? color : [UIColor colorWithRed:46/255.0  green:13/255.0 blue:14/255.0 alpha:1];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [pathColor CGColor];
    
    [view.layer addSublayer:shapeLayer];
    
}

+ (void) addRightCurveBezierPathToView: (UIView *) view inverted:(BOOL)inverted{
    [SHPathLibrary addRightCurveBezierPathToView:view withColor:nil inverted:inverted];
}

+ (UIBezierPath *) swipableRightCurvyBezierPathForView: (UIView *) view inLayer :(CAShapeLayer*)layer inverted:(BOOL)inverted{
    UIBezierPath* path = [SHPathLibrary swipableRightCurvyBezierPathForRect:view.frame inverted:inverted];
    
    [view.layer addSublayer:layer];
    return path;
}

+ (UIBezierPath *) swipableRightCurvyBezierPathForView: (UIView *) view inverted:(BOOL)inverted{
    UIBezierPath* path = [SHPathLibrary swipableRightCurvyBezierPathForRect:view.frame inverted:inverted];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor colorWithRed:61 green:22 blue:20 alpha:1] CGColor];

    [view.layer addSublayer:shapeLayer];
    
    return path;
}

+ (UIBezierPath *) swipableRightCurvyBezierPathForRect: (CGRect ) frame inverted:(BOOL)inverted{
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    float width = inverted ? 0 : CGRectGetWidth(frame);
    //width -= 40;
    int invertFactor = (inverted ? -1 : 1);;
    
    
    //Top base straight square
    [path moveToPoint:CGPointMake(width * 1.5f, 0)];
    [path addLineToPoint:CGPointMake(width * 1.1f , 0)];
    
    
    //Top curve
    float half = CGRectGetMidY(frame);
    //[path moveToPoint:CGPointMake(width, half - 100)];
    [path addLineToPoint:CGPointMake(width, half - 100)];
    
    
    float xpc1 = width - 20 * invertFactor;
    float yTopHalf = half - 50;
    
    [path addCurveToPoint:CGPointMake(xpc1, yTopHalf)
            controlPoint1:CGPointMake(xpc1 + (15 * invertFactor), half - 70)
            controlPoint2:CGPointMake(xpc1 , yTopHalf)];
    //Bump
    float xcp1B = width - 20 * invertFactor;
    float bumpX = xcp1B - 25 * invertFactor;
    
    [path addCurveToPoint:CGPointMake(xcp1B, half + 50)
            controlPoint1:CGPointMake(bumpX, half - 10)
            controlPoint2:CGPointMake(bumpX, half + 10)];
    
    //Bottom curve
    float yBotHalf = half+50;
    [path addCurveToPoint:CGPointMake(width, half + 100)
            controlPoint1:CGPointMake(xpc1, yBotHalf)
            controlPoint2:CGPointMake(xpc1 + (15 * invertFactor), half + 70)];
    
    
    //Bottom end straight square
    [path addLineToPoint:CGPointMake(width * 1.1f , CGRectGetHeight(frame))];
    [path addLineToPoint:CGPointMake(width * 1.5f, CGRectGetHeight(frame))];
    
    return path;
}

+ (UIBezierPath *) swippedRightCurvyBezierPathForRect: (CGRect ) frame inverted:(BOOL)inverted{
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    float width = 0;
    //float width = CGRectGetWidth(frame);
    
    //Top base straight square
    [path moveToPoint:CGPointMake(CGRectGetWidth(frame) * 1.5f, 0)];
    [path addLineToPoint:CGPointMake(width - 20, 0)];
    
    
    //Top curve
    float half = CGRectGetMidY(frame);
    //[path moveToPoint:CGPointMake(width, half - 100)];
    [path addLineToPoint:CGPointMake(width , half - 100)];
    

//    float xpc1 = width + 20 ;
    float yTopHalf = half - 50;
    
    [path addCurveToPoint:CGPointMake(0, yTopHalf)
            controlPoint1:CGPointMake(0 , half - 70)
            controlPoint2:CGPointMake(0 , yTopHalf)];
    
    /*[path addCurveToPoint:CGPointMake(xpc1, yTopHalf)
            controlPoint1:CGPointMake(xpc1 - 15 , half - 70)
            controlPoint2:CGPointMake(xpc1 , yTopHalf)];*/
    
    //Bump
    float xcp1B = width + 20;
//    float bumpX = xcp1B + 25;
    
    [path addCurveToPoint:CGPointMake(0, half + 50)
            controlPoint1:CGPointMake(0, half - 10)
            controlPoint2:CGPointMake(0, half + 10)];
    
    //Bottom curve
    float yBotHalf = half+50;
    
    [path addCurveToPoint:CGPointMake(0, half + 100)
            controlPoint1:CGPointMake(0, yBotHalf)
            controlPoint2:CGPointMake(0 - 15 , half + 70)];

    /*[path addCurveToPoint:CGPointMake(width, half + 100)
            controlPoint1:CGPointMake(xpc1, yBotHalf)
            controlPoint2:CGPointMake(xpc1 - 15 , half + 70)];*/
    
    
    //Bottom end straight square
    [path addLineToPoint:CGPointMake(width * 1.1f , CGRectGetHeight(frame))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(frame) * 1.5f, CGRectGetHeight(frame))];
    
    return path;
}

+ (UIBezierPath *)pathForHomeBubbleInRect:(CGRect)rect open:(BOOL)open {
    CGRect smallRect = open ? CGRectMake(-rect.size.width, -rect.size.height, rect.size.width*3, rect.size.height*3) :CGRectMake(CGRectGetMidX(rect) - 125, 50, 250, 250);
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:smallRect];
    
    return path;
}



#pragma mark - Transition Beetween Stories And Admin

+ (UIBezierPath *) pathForTransitionBeetweenStoriesAndAdmin: (CGRect) rect segueBack:(BOOL) back withFinalPath:(BOOL) finalPath{
    
    if(!back){
        return [SHPathLibrary pathForTransitionToAdminFromStories:rect withFinalPath:finalPath];
    }else{
        return [SHPathLibrary pathForTransitionFromAdminToStories:rect withFinalPath:finalPath];
    }
}

+ (UIBezierPath *) pathForTransitionToAdminFromStories: (CGRect) rect withFinalPath:(BOOL) finalPath{
    
    int bump = finalPath ? 150 : 0 ;
    
    float width = CGRectGetWidth(rect);
    float midX = CGRectGetMidX(rect);
    
    float height = finalPath ? CGRectGetHeight(rect) : 0;
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width, 0)];
    
    [path addLineToPoint:CGPointMake(width, height)]; //
    [path addQuadCurveToPoint: CGPointMake(0, height) controlPoint: CGPointMake(midX, height + bump)];//(
    [path addLineToPoint:CGPointMake(0, 0)]; // __^
    
    return path;
}

+ (UIBezierPath *) pathForTransitionFromAdminToStories: (CGRect) rect withFinalPath:(BOOL) finalPath{
    
    int bump = finalPath ? 0 : 150;
    
    float width = CGRectGetWidth(rect);
    float midX = CGRectGetMidX(rect);
    
    float height = CGRectGetHeight(rect);
    float curveEdgesY = finalPath ? 0 : CGRectGetHeight(rect);
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, curveEdgesY)];//.
    
    [path addQuadCurveToPoint: CGPointMake(width, curveEdgesY) controlPoint: CGPointMake(midX, curveEdgesY + bump)];//(
    
    [path addLineToPoint:CGPointMake(width, height)];//-!
    [path addLineToPoint:CGPointMake(0, height)]; //
    [path addLineToPoint:CGPointMake(0, curveEdgesY)]; // __^
    
    return path;
}


@end
