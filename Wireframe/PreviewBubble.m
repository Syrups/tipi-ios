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
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.hidden = YES;
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

- (void)appear {
    self.hidden = NO;
    [self animateUpdate];
}

- (void)hide {
    self.hidden = YES;
    [self animateUpdate];
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

- (void)animateUpdate {
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.3f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayer];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"morphing"];
    
    [shapeLayer.modelLayer setPath:to];
}

- (CGPathRef)pathForLayer {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(self.frame.size.width, 150)];
    
    if (self.hidden) {
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-150)];
    } else {
        [path addQuadCurveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - 150) controlPoint:CGPointMake(self.frame.size.width/3, self.frame.size.height/2)];
    }
    
    
    return path.CGPath;
}

- (CGPathRef)pathForLayerExpanded {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(self.frame.size.width, -self.frame.size.height)];

    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width, 2*self.frame.size.height) controlPoint:CGPointMake(-self.frame.size.width*2, self.frame.size.height/2)];
    
    
    return path.CGPath;

}

@end