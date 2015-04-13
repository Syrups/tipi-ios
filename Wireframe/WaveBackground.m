//
//  WaveBackground.m
//  Wireframe
//
//  Created by Leo on 06/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WaveBackground.h"

@implementation WaveBackground {
    CAShapeLayer* shapeLayer;
    UIImageView* _image;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        image.image = [UIImage imageNamed:@"wave-buddy-left.png"];
        image.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:image];
        
        self.backgroundColor = RgbColorAlpha(43, 75, 122, 1);
        
        _image = image;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPathRef path = [self pathForLayer];
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = CGPathCreateCopy(path);
//    layer.fillColor = RgbColorAlpha(43, 75, 122, 0).CGColor;
    
    shapeLayer = layer;
    self.layer.mask = layer;
    
}

- (void)shuffle {
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.2f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayer];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"morphing"];
    
    [shapeLayer.modelLayer setPath:to];

}

- (void)grow {
    
//    CGRect frame = self.frame;
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.frame = frame;
        _image.alpha = 0;
    } completion:nil];
    

    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.2f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayerGrownState];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"growing"];
    
    [shapeLayer.modelLayer setPath:to];
}

- (CGPathRef)pathForLayer {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGPoint start = CGPointMake(0, 130 + arc4random_uniform(20));
    CGPoint end = CGPointMake(self.frame.size.width, start.y - 25 + arc4random_uniform(30));
    CGPoint c1 = CGPointMake(CGRectGetMidX(self.frame) - 10 - arc4random_uniform(20), start.y + arc4random_uniform(30) + 20);
    CGPoint c2 = CGPointMake(CGRectGetMidX(self.frame) + 10 + arc4random_uniform(20), start.y - (arc4random_uniform(30) + 20));
    
    [path moveToPoint:start];
    [path addCurveToPoint:end controlPoint1:c1 controlPoint2:c2];
    
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path addLineToPoint:start];
    
    return path.CGPath;
}

- (CGPathRef)pathForLayerGrownState {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGPoint start = CGPointMake(0, 80);
    CGPoint end = CGPointMake(self.frame.size.width, 10);
    CGPoint c1 = CGPointMake(CGRectGetMidX(self.frame) - 10, start.y);
    CGPoint c2 = CGPointMake(CGRectGetMidX(self.frame) + 10, start.y - 20);
    
    [path moveToPoint:start];
    [path addCurveToPoint:end controlPoint1:c1 controlPoint2:c2];
    
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path addLineToPoint:start];
    
    return path.CGPath;
}

@end
