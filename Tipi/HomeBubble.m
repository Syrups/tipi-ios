//
//  HomeBubble.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "HomeBubble.h"
#import "SHPathLibrary.h"
#import "PKAIDecoder.h"

@implementation HomeBubble {
    CAShapeLayer* shapeLayer;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        CGFloat midX = CGRectGetMidX(self.frame);
        CGFloat midY = CGRectGetMidY(self.frame);
        
        UIImageView* wave1 = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 50, midY - 50, 100, 50)];
        [PKAIDecoder builAnimatedImageIn:wave1 fromFile:@"onde_bleu_clair" withAnimationDuration:3];
        UIImageView* wave2 = [[UIImageView alloc] initWithFrame:CGRectMake(midX + 50, midY - 30, 100, 50)];
        [PKAIDecoder builAnimatedImageIn:wave2 fromFile:@"onde_bleu" withAnimationDuration:3];
        UIImageView* star1 = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 20, midY + 50, 60, 60)];
        [PKAIDecoder builAnimatedImageIn:star1 fromFile:@"star" withAnimationDuration:3];
        UIImageView* buddy = [[UIImageView alloc] initWithFrame:self.frame];
//        buddy.transform = CGAffineTransformMakeTranslation(0, 100);
        [PKAIDecoder builAnimatedImageIn:buddy fromFile:@"tete" withAnimationDuration:4];
//        UIImageView* voice = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 130, midY - 60, 100, 40)];
//        [PKAIDecoder builAnimatedImageIn:voice fromFile:@"onde_voix" withAnimationDuration:3];
        [self addSubview:buddy];
        [self addSubview:wave1];
        [self addSubview:wave2];
        [self addSubview:star1];
        
//        [self addSubview:voice];
        
        self.layer.backgroundColor = self.backgroundColor.CGColor;
    }
    return self;
}

- (void)expand {
    CGPathRef to = [SHPathLibrary pathForHomeBubbleInRect:self.frame open:YES].CGPath;

    [shapeLayer setPath:to];
    [shapeLayer.modelLayer setPath:to];

    self.expanded = YES;
}

- (void)appear {
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.4f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CGPathRef from = [SHPathLibrary pathForHomeBubbleInRect:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0) open:NO].CGPath;
    CGPathRef to = [SHPathLibrary pathForHomeBubbleInRect:self.frame open:NO].CGPath;
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"appear"];
    [shapeLayer.modelLayer setPath:to];
}

- (void)expandWithCompletion:(void (^)())completionBlock backgroundFading:(BOOL)fading {
    
    if (fading) {
        UIView* overlay = [[UIView alloc] initWithFrame:self.frame];
        overlay.backgroundColor = kListenBackgroundColor;
        overlay.alpha = 0;
        [self addSubview:overlay];
        [UIView animateWithDuration:.4f animations:^{
            overlay.alpha = 1;
        } completion:^(BOOL finished) {
            [overlay removeFromSuperview];
        }];
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completionBlock];
    
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.4f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [SHPathLibrary pathForHomeBubbleInRect:self.frame open:YES].CGPath;
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"expand"];
    [shapeLayer.modelLayer setPath:to];
    
    [CATransaction commit];
    
    self.expanded = YES;
}

- (void)reduceWithCompletion:(void (^)())completionBlock backgroundFading:(BOOL)fading {
    if (fading) {
        UIView* overlay = [[UIView alloc] initWithFrame:self.frame];
        overlay.backgroundColor = kListenBackgroundColor;
        overlay.alpha = 1;
        [self addSubview:overlay];
        [UIView animateWithDuration:.3f animations:^{
            overlay.alpha = 0;
        } completion:^(BOOL finished) {
            [overlay removeFromSuperview];
        }];
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completionBlock];
    
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.3f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CGPathRef from = [SHPathLibrary pathForHomeBubbleInRect:self.frame open:YES].CGPath;
    CGPathRef to = [SHPathLibrary pathForHomeBubbleInRect:self.frame open:NO].CGPath;
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"reduce"];
    [shapeLayer.modelLayer setPath:to];
    
    [CATransaction commit];
    
    [UIView animateWithDuration:.4f animations:^{
        for (UIView* v in self.subviews) {
            v.alpha = 1;
        }
    }];
    
    self.expanded = NO;
}

- (void)stickTopTopWithCompletion:(void (^)())completionBlock {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completionBlock];
    
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.4f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [SHPathLibrary pathForHomeBubbleStickyToTopInRect:self.frame].CGPath;
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"expand"];
    [shapeLayer.modelLayer setPath:to];
    
    [CATransaction commit];
    
    [UIView animateWithDuration:.4f animations:^{
        for (UIView* v in self.subviews) {
            v.alpha = 0;
        }
    }];
    

}

- (void)drawRect:(CGRect)rect {
    CGPathRef path = [SHPathLibrary pathForHomeBubbleInRect:self.frame open:self.expanded].CGPath;
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = CGPathCreateCopy(path);
    //    layer.fillColor = RgbColorAlpha(43, 75, 122, 0.8f).CGColor;
    self.layer.mask = layer;
    shapeLayer = layer;
}

@end
