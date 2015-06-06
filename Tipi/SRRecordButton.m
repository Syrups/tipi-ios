//
//  SRRecordButton.m
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SRRecordButton.h"
#import "Configuration.h"

#define DEGREES_TO_RADIANS(deg) deg * (M_PI / 180)
#define SEGMENTED NO

@implementation SRRecordButton {
    NSTimer* timer;
    CGFloat circleOffset;
    CGFloat startAngle;
    NSTimer* appearanceTimer;
    NSTimer* closingTimer;
    CGFloat lastValue;
    float* _buffer;
    UInt32 _bufferSize;
    UInt32 t;
    BOOL recording;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.currentTime = 0.0f;
    circleOffset = -90;
    
    self = [super initWithCoder:aDecoder];
    self.backgroundColor = [UIColor clearColor];
    
    [self setContentMode:UIViewContentModeRedraw];
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.wave = [[SCSiriWaveformView alloc] initWithFrame:CGRectMake(center.x - 80, center.y - 80, 160, 160)];
    self.wave.backgroundColor = [UIColor clearColor];
    self.wave.idleAmplitude = .1f;
    self.wave.frequency = 2;
    self.wave.alpha = 0;
    
    [self addSubview:self.wave];
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame totalDuration:(CGFloat)total {
    self.currentTime = 0.0f;
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    [self setContentMode:UIViewContentModeRedraw];
    
    return self;
}

#pragma mark - Appearing and closing animations

- (void)appear {
    self.alpha = 1;
    circleOffset = -90;
    appearanceTimer = [NSTimer scheduledTimerWithTimeInterval:0.005f target:self selector:@selector(updateAppearing) userInfo:nil repeats:YES];
    self.appeared = YES;
}

- (void)close {
    _bufferSize = 0;
    _buffer = NULL;
    closingTimer = [NSTimer scheduledTimerWithTimeInterval:0.005f target:self selector:@selector(updateClosing) userInfo:nil repeats:YES];
    self.appeared = NO;

}

- (void)hide {
    circleOffset = -self.frame.size.width/2 + 30;
    self.appeared = NO;
    [self setNeedsDisplay];
}

- (void)updateAppearing {
    
    circleOffset += 3;
    
    if (circleOffset >= 10) {
        circleOffset = 10;
        [appearanceTimer invalidate];
    }
//    
//    if (self.currentTime >= self.duration) {
//        startAngle += .5f;
//        
//        if (startAngle >= M_2_PI) {
//            startAngle = 0;
//            self.currentTime = 0;
//        }
//    } else {
//        self.currentTime += .7f;
//    }

    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}

- (void)updateClosing {
    circleOffset -= 3.5f;
    
    if (circleOffset <= -90) {
        [closingTimer invalidate];
        self.alpha = 0;
    }
    
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}

#pragma mark - Timer

- (void)start {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(update) userInfo:nil repeats:YES];

    recording = YES;
    
    [UIView animateWithDuration:.2f animations:^{
        self.wave.alpha = 1;
    }];
}

- (void)pause {
    [timer invalidate];
    recording = NO;
    
    [UIView animateWithDuration:.2f animations:^{
        self.wave.alpha = 0;
    }];

}

- (void)reset {
    [timer invalidate];
    recording = NO;
    self.currentTime = 0;
    circleOffset = 10;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat radius = 90;
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 4.0f);
    
    // draw first circle

//    if (_bufferSize == 0) {
//        for (int a = 0 ; a < 360 ; a++) {
//            
//            r = radius + circleOffset;
////            float offset = sin(DEGREES_TO_RADIANS(a) * 6 + t) * 5;
//            float offset = 0;
//            float cx = frame.size.width/2 + r * cos(a * M_PI / 180) + offset;
//            float cy = frame.size.height/2 + r * sin(a * M_PI / 180) + offset;
//            if (a == 0) CGContextMoveToPoint(ctx, cx, cy);
//            
//            if (SEGMENTED) {
//                if ((a + t) % 3 == 0) {
//                    CGContextAddEllipseInRect(ctx, CGRectMake(cx - 1, cy - 1, 2, 2));
//                    CGContextFillPath(ctx);
//                }
//            } else {
//                CGContextAddLineToPoint(ctx, cx, cy);
//            }
//            
//        }
//    } else {
//        for (int i = 0 ; i < _bufferSize ; i++) {
//            
//            
//            // Here is magic!
//            // serioulsy no idea what I'm doing, just testing some random
//            // math stuff, but it seems to work out pretty
//            
//            int a = (i+1) * 360 / _bufferSize;
////            float delta = _buffer[i] * 100 * sin(DEGREES_TO_RADIANS(a) * 12 + t);
//            float delta = 0, offset = 0;
//            r = radius + circleOffset + delta;
////            float offset = sin(DEGREES_TO_RADIANS(a) * 6 + t) * 2;
//            float cx = frame.size.width/2 + r * cos(a * M_PI / 180) + offset;
//            float cy = frame.size.height/2 + r * sin(a * M_PI / 180) + offset;
//            if (i == 0) CGContextMoveToPoint(ctx, cx, cy);
//            
//            if (SEGMENTED) {
//                if ((a + t) % 3 == 0) {
//                    CGContextAddEllipseInRect(ctx, CGRectMake(cx - 1, cy - 1, 3, 3));
//                    CGContextFillPath(ctx);
//                }
//            } else {
//                CGContextAddLineToPoint(ctx, cx, cy);
//            }
//            
//          
//        }
//    }
//    
//    if (!SEGMENTED) {
//        CGContextClosePath(ctx);
//        CGContextStrokePath(ctx);
//    }
//
//    CGContextRestoreGState(ctx);
    
    // outer circle
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, radius + circleOffset, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, 4.0f);
    CGContextStrokePath(ctx);

    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, radius + circleOffset, -M_PI_2 + startAngle, [self getAnglePercent], 0);
    CGContextSetStrokeColorWithColor(ctx, self.fillColor.CGColor);
    CGContextSetLineWidth(ctx, 4.0f);
    CGContextStrokePath(ctx);

    [super drawRect:rect];
}

- (CGFloat)getAnglePercent {
    return startAngle + (-M_PI_2 + (M_PI*2 * self.currentTime) / self.duration);
}


- (void)update {
    
    t++;
    
    if (recording) {
    
        if (self.duration <= self.currentTime) return;
        
        self.currentTime += 0.05f;
        [self setNeedsDisplay];
        [self setContentMode:UIViewContentModeRedraw];
        
//        circleOffset -= 0.05f;
        
    }
}

- (void)updateWithBuffer:(float **)buffer bufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    float* channel = buffer[0];
    
    _buffer = buffer[0];
    _bufferSize = bufferSize;
    float avg = 0;
    
    for (int i = 0 ; i < bufferSize ; ++i) {
        avg += *(channel + i);
    }
 
    lastValue = avg / 30;
}

- (void)updateWave {
    [self.wave updateWithLevel:(recording ? .4f : .1f)];
}

@end

