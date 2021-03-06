//
//  PreviewBubble.m
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "PreviewBubble.h"

@implementation PreviewBubble {
    CAShapeLayer* shapeLayer;
    CGFloat lastX;
    CGFloat expandOffset;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.hidden = YES;
//        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPathRef path = [self pathForLayer];
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = CGPathCreateCopy(path);
    
    shapeLayer = layer;
    self.layer.mask = layer;
}

- (void)updateWithImage:(UIImage *)image {
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat ratio = image.size.width / image.size.height;
    
    if (ratio > 1) {
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        
        imageView.bounds = CGRectMake(0, 0, self.frame.size.height * ratio, self.frame.size.height);
        
        scrollView.userInteractionEnabled = NO;
        
        scrollView.contentSize = imageView.bounds.size;
        scrollView.zoomScale = (CGRectGetHeight(scrollView.bounds) / CGRectGetWidth(scrollView.bounds)) * (image.size.width / image.size.height);
        
        [scrollView addSubview:imageView];
        [self addSubview:scrollView];
    }
    
    [self addSubview:imageView];
    
    [self setNeedsDisplay];
}

- (void)appearWithCompletion:(void (^)())completionBlock {
    self.hidden = NO;
    [self animateUpdateWithCompletion:completionBlock];
}

- (void)hideWithCompletion:(void (^)())completionBlock {
    self.hidden = YES;
    [self animateUpdateWithCompletion:completionBlock];
}

- (void)close {
    self.hidden = YES;
    self.expanded = NO;
    [self setNeedsDisplay];
}

- (void)expandWithCompletion:(void (^)())completionBlock {
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:completionBlock];
    
    self.expanded = YES;
    
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
}

- (void)animateUpdateWithCompletion:(void (^)())completionBlock {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completionBlock];
    
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.2f;
    morph.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1:.23:.9:.59];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayer];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"morphing"];
    
    [shapeLayer.modelLayer setPath:to];
    
    [CATransaction commit];
}

- (CGPathRef)pathForLayer {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGPoint start = CGPointMake(self.frame.size.width, 200 - (4*expandOffset));
    CGPoint end =   CGPointMake(self.frame.size.width, self.frame.size.height - 200 + (4*expandOffset));
    CGPoint mid =   CGPointMake(self.frame.size.width - 100, self.frame.size.height/2);
    CGPoint c1 =    CGPointMake(self.frame.size.width - 20, start.y + 20);
    CGPoint c2 =    CGPointMake(self.frame.size.width - 100, start.y);
    CGPoint c3 =    CGPointMake(self.frame.size.width - 100, end.y);
    CGPoint c4 =    CGPointMake(self.frame.size.width - 20, end.y - 20);
    
    [path moveToPoint:start];
    
    if (self.hidden) {
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-150)];
    } else {
        [path addCurveToPoint:mid controlPoint1:c1 controlPoint2:c2];
        [path addCurveToPoint:end controlPoint1:c3 controlPoint2:c4];
    }
    
    
    return path.CGPath;
}

- (CGPathRef)pathForLayerExpanded {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGPoint start = CGPointMake(self.frame.size.width, -self.frame.size.height);
    CGPoint end =   CGPointMake(self.frame.size.width, self.frame.size.height*2);
    CGPoint mid =   CGPointMake(-self.frame.size.width, self.frame.size.height/2);
    CGPoint c1 =    CGPointMake(self.frame.size.width - 20, start.y + 20);
    CGPoint c2 =    CGPointMake(-self.frame.size.width - 120, start.y);
    CGPoint c3 =    CGPointMake(-self.frame.size.width - 120, end.y);
    CGPoint c4 =    CGPointMake(self.frame.size.width - 20, end.y - 20);
    
    [path moveToPoint:start];

    [path addCurveToPoint:mid controlPoint1:c1 controlPoint2:c2];
    [path addCurveToPoint:end controlPoint1:c3 controlPoint2:c4];
    
    return path.CGPath;

}

#pragma mark - Drag

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    lastX = location.x;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    CGFloat deltaX = lastX - location.x;
    
    NSLog(@"%f", deltaX);
    
    if (deltaX > 0) {
        expandOffset += 2;
    }
    
    if (expandOffset > 10) {
        [self.delegate previewBubbleDidDragToExpand:self];
        self.userInteractionEnabled = NO;
    }
    
    [self setNeedsDisplay];
}

@end
