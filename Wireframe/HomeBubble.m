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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat midX = CGRectGetMidX(self.frame);
        CGFloat midY = CGRectGetMidY(self.frame);
        
        UIImageView* wave1 = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 150, midY - 150, 100, 50)];
        [PKAIDecoder builAnimatedImageIn:wave1 fromFile:@"onde_bleu_clair"];
        UIImageView* wave2 = [[UIImageView alloc] initWithFrame:CGRectMake(midX + 80, midY - 70, 100, 50)];
        [PKAIDecoder builAnimatedImageIn:wave2 fromFile:@"onde_bleu"];
        UIImageView* star1 = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 140, midY - 100, 60, 60)];
        [PKAIDecoder builAnimatedImageIn:star1 fromFile:@"star"];
        UIImageView* buddy = [[UIImageView alloc] initWithFrame:self.frame];
        [PKAIDecoder builAnimatedImageIn:buddy fromFile:@"tete"];
        UIImageView* voice = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 130, midY - 60, 100, 40)];
        [PKAIDecoder builAnimatedImageIn:voice fromFile:@"onde_voix"];
        
        [self addSubview:wave1];
        [self addSubview:wave2];
        [self addSubview:star1];
        [self addSubview:buddy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        CGFloat midX = CGRectGetMidX(self.frame);
        CGFloat midY = CGRectGetMidY(self.frame);
        
        UIImageView* wave1 = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 150, midY - 150, 100, 50)];
        [PKAIDecoder builAnimatedImageIn:wave1 fromFile:@"onde_bleu_clair"];
        UIImageView* wave2 = [[UIImageView alloc] initWithFrame:CGRectMake(midX + 80, midY - 70, 100, 50)];
        [PKAIDecoder builAnimatedImageIn:wave2 fromFile:@"onde_bleu"];
        UIImageView* star1 = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 140, midY - 100, 60, 60)];
        [PKAIDecoder builAnimatedImageIn:star1 fromFile:@"star"];
        UIImageView* buddy = [[UIImageView alloc] initWithFrame:self.frame];
        [PKAIDecoder builAnimatedImageIn:buddy fromFile:@"tete"];
        UIImageView* voice = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 130, midY - 60, 100, 40)];
        [PKAIDecoder builAnimatedImageIn:voice fromFile:@"onde_voix"];
        
        [self addSubview:wave1];
        [self addSubview:wave2];
        [self addSubview:star1];
        [self addSubview:buddy];
//        [self addSubview:voice];
    }
    return self;
}

- (void)zoomOut {
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.3f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [SHPathLibrary pathForHomeBubbleInRect:self.frame open:NO].CGPath;
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"zoomOut"];
    
    [shapeLayer.modelLayer setPath:to];
}

- (void)drawRect:(CGRect)rect {
    CGPathRef path = [SHPathLibrary pathForHomeBubbleInRect:self.frame open:YES].CGPath;
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = CGPathCreateCopy(path);
    //    layer.fillColor = RgbColorAlpha(43, 75, 122, 0.8f).CGColor;
    self.layer.mask = layer;
    shapeLayer = layer;
}

@end
