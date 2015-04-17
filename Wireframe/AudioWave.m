//
//  AudioWave.m
//  Wireframe
//
//  Created by Leo on 14/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AudioWave.h"
static const CGFloat kDefaultFrequency          = 1.5f;
static const CGFloat kDefaultAmplitude          = 1.0f;
static const CGFloat kDefaultIdleAmplitude      = 0.01f;
static const CGFloat kDefaultNumberOfWaves      = 5.0f;
static const CGFloat kDefaultPhaseShift         = -0.15f;
static const CGFloat kDefaultDensity            = 5.0f;
static const CGFloat kDefaultPrimaryLineWidth   = 3.0f;
static const CGFloat kDefaultSecondaryLineWidth = 1.0f;

@interface AudioWave ()

@property (nonatomic, assign) CGFloat phase;
@property (nonatomic, assign) CGFloat amplitude;

@end


@implementation AudioWave {
    CAShapeLayer* shapeLayer;
    BOOL animating;
    CGFloat audioRate;
    CGFloat lastValue;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateSelf)];
        [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        self.backgroundColor = RgbColorAlpha(43, 75, 122, 0.4f);
        
        self.frequency = kDefaultFrequency;
        
        self.amplitude = kDefaultAmplitude;
        self.idleAmplitude = kDefaultIdleAmplitude;
        
        self.numberOfWaves = kDefaultNumberOfWaves;
        self.phaseShift = kDefaultPhaseShift;
        self.density = kDefaultDensity;
        
        self.primaryWaveLineWidth = kDefaultPrimaryLineWidth;
        self.secondaryWaveLineWidth = kDefaultSecondaryLineWidth;
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



- (CGPathRef)pathForLayer{
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat mid = width / 2.0f;
    
    const CGFloat maxAmplitude = halfHeight - 4.0f; // 4 corresponds to twice the stroke width
    
    CGFloat o = !self.deployed ? self.frame.size.height + 50 : self.frame.size.height/2 + 50;
    
    CGPoint start = CGPointMake(0, o - arc4random_uniform(audioRate));

    [path moveToPoint:start];
    //[path addCurveToPoint:end controlPoint1:c1 controlPoint2:c2];
    
    for (CGFloat x = 0; x<width + self.density; x += self.density) {
        // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
        CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
        
        CGFloat y = scaling * maxAmplitude * self.amplitude * sinf(2 * M_PI *(x / width) * self.frequency + self.phase) + halfHeight;
        
        if (x == 0) {
            [path moveToPoint:CGPointMake(x, y)];
        } else {
            //CGContextAddLineToPoint(context, x, y);
            [path addLineToPoint:CGPointMake(x, y)];
        }
    }
    
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

- (void)updateWithBuffer:(float **)buffer bufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    float* channel = buffer[0];
    
    CGFloat max = 0.0;
    for (int i = 0 ; i < bufferSize ; ++i) {
        if (*(channel+i) > max && *(channel+i) < .1f) max = *(channel+i);
    }
    
    lastValue = max;
}


- (void)updateWithLevel:(CGFloat)level
{
    self.phase += self.phaseShift;
    self.amplitude = fmax(level, self.idleAmplitude);
    self.backgroundColor = self.deployed ? RgbColorAlpha(43, 75, 122, 0.8f) :  RgbColorAlpha(43, 75, 122, 0.4f);
    
    [self setNeedsDisplay];
}

- (void)updateSelf
{
       [self updateWithLevel:lastValue];
}

@end
