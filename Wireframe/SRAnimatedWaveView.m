//
//  SRAnimatedWaveView.m
//  Wireframe
//
//  Created by Glenn Sonna on 06/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SRAnimatedWaveView.h"

static CGFloat const kSeconds = 5.25;
float w = 0;//starting x value.

@implementation SRAnimatedWaveView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self startDisplayLink];
    }
    
    return self;
}

- (void)startDisplayLink
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    if (!self.firstTimestamp)
        self.firstTimestamp = displayLink.timestamp;
    
    self.displayLinkTimestamp = displayLink.timestamp;
    
    self.loopCount++;
    
    [self setNeedsDisplayInRect:self.bounds];
    
    
    
    NSTimeInterval elapsed = (displayLink.timestamp - self.firstTimestamp);
    
    
    if (elapsed >= kSeconds)
    {
        [self stopDisplayLink];
        self.displayLinkTimestamp = self.firstTimestamp + kSeconds;
        [self setNeedsDisplayInRect:self.bounds];
        //self.statusLabel.text = [NSString stringWithFormat:@"loopCount = %.1f frames/sec", self.loopCount / kSeconds];
    }
}

- (UIBezierPath *)pathAtInterval:(NSTimeInterval) interval
{
    
    CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
    CGFloat width = CGRectGetWidth(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.bounds.size.height / 2.0)];
    
    CGFloat fractionOfSecond = interval - floor(interval);
    
    CGFloat yOffset = self.bounds.size.height * sin(fractionOfSecond * M_PI * 2.0);
    CGFloat xOffset = self.bounds.size.width * fractionOfSecond * M_PI * 2.0;
    
    NSLog(@"%f / %f for %f",xOffset, self.bounds.size.width, fractionOfSecond);
    
    [path addQuadCurveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height / 2 ) controlPoint:CGPointMake(xOffset, self.bounds.size.height * 0.2 )];
    
    /*[path addCurveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height / 2.0)
            controlPoint1:CGPointMake(xOffset, self.bounds.size.height / 2.0 - 150)
            controlPoint2:CGPointMake(self.bounds.size.width , self.bounds.size.height / 2.0 + 150)];*/
    
    const CGFloat maxAmplitude = halfHeight - 4.0f; // 4 corresponds to twice the stroke width
    
    for (CGFloat x = 0; x<width + 5.0f; x += 5.0f) {
        
        /*if (x == 0) {
            [path moveToPoint:CGPointMake(x, yOffset)];
        } else {
            [path addLineToPoint:CGPointMake(x, yOffset)];
        }*/
        
    }
    
   

    return path;
}


- (void)drawRect:(CGRect)rect
{
    //[self drawWake];
    
    NSTimeInterval elapsed = (self.displayLinkTimestamp - self.firstTimestamp);
    
    UIBezierPath *path = [self pathAtInterval:elapsed];
    
    [[UIColor redColor] setStroke];
    path.lineWidth = 3.0;
    [path stroke];
}


@end
