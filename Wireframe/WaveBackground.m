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
    CGPathRef path = self.openByDefault ? [self pathForLayer] : [self pathForLayerClosed];
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

- (void)appear {
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.2f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayer];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"appearing"];
    
    [shapeLayer.modelLayer setPath:to];
}


- (CGPathRef)pathForLayer {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGPoint start = CGPointMake(0, 180);
    CGPoint middle = CGPointMake(CGRectGetMidX(self.frame), 280);
    CGPoint end = CGPointMake(CGRectGetWidth(self.frame), 180);
    
    // control points
    CGPoint c1 = CGPointMake(CGRectGetMidX(self.frame)*.75f, 220);
    CGPoint c2 = CGPointMake(CGRectGetMidX(self.frame)*.5f, 280);
    
    CGPoint c3 = CGPointMake(CGRectGetMidX(self.frame) + CGRectGetMidX(self.frame)*.5f, 280);
    CGPoint c4 = CGPointMake(CGRectGetMidX(self.frame) + CGRectGetMidX(self.frame)*.25f, 220);
    
    [path moveToPoint:start];
    [path addCurveToPoint:middle controlPoint1:c1 controlPoint2:c2];
    [path addCurveToPoint:end controlPoint1:c3 controlPoint2:c4];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:start];
    
    return path.CGPath;
}

- (CGPathRef)pathForLayerClosed {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGPoint start = CGPointMake(0, 0);
    CGPoint middle = CGPointMake(CGRectGetMidX(self.frame), 0);
    CGPoint end = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    // control points
    CGPoint c1 = CGPointMake(CGRectGetMidX(self.frame)*.75f, 0);
    CGPoint c2 = CGPointMake(CGRectGetMidX(self.frame)*.5f, 0);
    
    CGPoint c3 = CGPointMake(CGRectGetMidX(self.frame) + CGRectGetMidX(self.frame)*.5f, 0);
    CGPoint c4 = CGPointMake(CGRectGetMidX(self.frame) + CGRectGetMidX(self.frame)*.25f, 0);
    
    [path moveToPoint:start];
    [path addCurveToPoint:middle controlPoint1:c1 controlPoint2:c2];
    [path addCurveToPoint:end controlPoint1:c3 controlPoint2:c4];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:start];
    
    return path.CGPath;
}


@end
