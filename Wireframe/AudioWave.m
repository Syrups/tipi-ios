//
//  AudioWave.m
//  Wireframe
//
//  Created by Leo on 14/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AudioWave.h"

@implementation AudioWave {
    CAShapeLayer* shapeLayer;
    BOOL animating;
    CGFloat audioRate;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = RgbColorAlpha(43, 75, 122, 0.8f);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPathRef path = [self pathForLayer];
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = CGPathCreateCopy(path);
//    layer.fillColor = RgbColorAlpha(43, 75, 122, 0.8f).CGColor;
    self.layer.mask = layer;
    shapeLayer = layer;
}



- (CGPathRef)pathForLayer {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGFloat o = !self.deployed ? self.frame.size.height + 50 : self.frame.size.height/2 + 50;
    
    CGPoint start = CGPointMake(0, o - arc4random_uniform(audioRate));
    CGPoint c1 = CGPointMake(CGRectGetMidX(self.frame) - 30 - arc4random_uniform(20), start.y + arc4random_uniform(audioRate) + 50);
    CGPoint c2 = CGPointMake(CGRectGetMidX(self.frame) + 30 + arc4random_uniform(20), start.y - (arc4random_uniform(audioRate) + 50));
    CGPoint end = CGPointMake(self.frame.size.width, start.y - arc4random_uniform(audioRate));
    
    [path moveToPoint:start];
    [path addCurveToPoint:end controlPoint1:c1 controlPoint2:c2];
    
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path addLineToPoint:start];
    
    return path.CGPath;
}

- (void)hide {
    self.deployed = NO;
    
    [self performSelectorOnMainThread:@selector(morph) withObject:nil waitUntilDone:NO];
}

- (void)morph {
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        animating = NO;
    }];
    
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.2f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayer];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"growing"];
    [shapeLayer.modelLayer setPath:to];
    
    [CATransaction commit];
}

- (void)updateBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize {
    
    if (animating) return;
    animating = YES;
    
    CGFloat max = 0;
    
    for (int i = 0 ; i < bufferSize ; i++) {
        if (max < buffer[i])
            max = buffer[i];
    }
    
    audioRate = max * 500;
    
    [self performSelectorOnMainThread:@selector(morph) withObject:nil waitUntilDone:NO];
    
}

@end
