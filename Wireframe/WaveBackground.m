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
//        image.image = [UIImage imageNamed:@"wave-buddy-left.png"];
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

- (void)updateImage:(UIImage *)image {
    UIImageView* newImageView = [[UIImageView alloc] initWithFrame:_image.frame];
    newImageView.contentMode = UIViewContentModeScaleAspectFill;
    newImageView.image = image;
    newImageView.alpha = 0;
    [self addSubview:newImageView];
    
    [UIView animateWithDuration:.2f animations:^{
        _image.alpha = 0;
        newImageView.alpha = .1f;
        [_image removeFromSuperview];
        _image = newImageView;
    }];
    
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
    
    if (self.growingAmount == 45) {
        return;
    }
    
    self.growingAmount++;
    [self update];
}

- (void)ungrow {
    self.growingAmount--;
    [self update];
}

- (void)update {
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.2f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayer];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"growing"];
    
    [shapeLayer.modelLayer setPath:to];
}

- (CGPathRef)pathForLayer {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGPoint start = CGPointMake(0, 150);
    CGPoint middle = CGPointMake(CGRectGetMidX(self.frame), 250);
    CGPoint end = CGPointMake(CGRectGetWidth(self.frame), 150);
    
    // control points
    CGPoint c1 = CGPointMake(CGRectGetMidX(self.frame)*.75f, 150);
    CGPoint c2 = CGPointMake(CGRectGetMidX(self.frame)*.5f, 250);
    
    CGPoint c3 = CGPointMake(CGRectGetMidX(self.frame) + CGRectGetMidX(self.frame)*.5f, 250);
    CGPoint c4 = CGPointMake(CGRectGetMidX(self.frame) + CGRectGetMidX(self.frame)*.25f, 150);
    
    [path moveToPoint:start];
    [path addCurveToPoint:middle controlPoint1:c1 controlPoint2:c2];
    [path addCurveToPoint:end controlPoint1:c3 controlPoint2:c4];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:start];
    
    
//    CGFloat o = self.frame.size.width/2;
//    
//    CGPoint start = CGPointMake(0, o + arc4random_uniform(20));
//    CGPoint middle = CGPointMake(self.frame.size.width/2, start.y - 25 + arc4random_uniform(30));
//    CGPoint c1 = CGPointMake(CGRectGetMidX(self.frame)/2 - 10 - arc4random_uniform(20), start.y + arc4random_uniform(30) + 20);
//    CGPoint c2 = CGPointMake(CGRectGetMidX(self.frame)/2 + 10 + arc4random_uniform(20), start.y - (arc4random_uniform(30) + 20));
//    CGPoint c3 = CGPointMake(CGRectGetMidX(self.frame)*1.5 - 10 - arc4random_uniform(20), middle.y );
//    CGPoint c4 = CGPointMake(CGRectGetMidX(self.frame)*1.5 + 10 + arc4random_uniform(20), middle.y - (arc4random_uniform(30) + 20));
//    CGPoint end = CGPointMake(self.frame.size.width, start.y - 50 + arc4random_uniform(30));
//    
//    [path moveToPoint:start];
//    [path addCurveToPoint:middle controlPoint1:c1 controlPoint2:c2];
//    [path addCurveToPoint:end controlPoint1:c3 controlPoint2:c4];
//    
//    [path addLineToPoint:CGPointMake(self.frame.size.width, 0)];
//    [path addLineToPoint:CGPointMake(0, 0)];
//    [path addLineToPoint:start];
    
    return path.CGPath;
}


@end
