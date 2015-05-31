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
#define SEGMENTED YES

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
    circleOffset = 10;
    
    self = [super initWithCoder:aDecoder];
    self.backgroundColor = [UIColor clearColor];
    
    [self setContentMode:UIViewContentModeRedraw];
    
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
    circleOffset = -self.frame.size.width/2 + 30;
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
    
    if (circleOffset <= -self.frame.size.width/2 + 30) {
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
}

- (void)pause {
    [timer invalidate];
    recording = NO;
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
    
    CGRect frame = self.bounds;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat radius = 90;
    CGFloat r;
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 8.0f);
    
    // draw first circle

    if (_bufferSize == 0) {
        for (int a = 0 ; a < 360 ; a++) {
            
            r = radius + circleOffset;
//            float offset = sin(DEGREES_TO_RADIANS(a) * 6 + t) * 5;
            float offset = 0;
            float cx = frame.size.width/2 + r * cos(a * M_PI / 180) + offset;
            float cy = frame.size.height/2 + r * sin(a * M_PI / 180) + offset;
            if (a == 0) CGContextMoveToPoint(ctx, cx, cy);
            
            if (SEGMENTED) {
                if ((a + t) % 3 == 0) {
                    CGContextAddEllipseInRect(ctx, CGRectMake(cx - 1, cy - 1, 2, 2));
                    CGContextFillPath(ctx);
                }
            } else {
                CGContextAddLineToPoint(ctx, cx, cy);
            }
            
        }
    } else {
        for (int i = 0 ; i < _bufferSize ; i++) {
            
            
            // Here is magic!
            // serioulsy no idea what I'm doing, just testing some random
            // math stuff, but it seems to work out pretty
            
            int a = (i+1) * 360 / _bufferSize;
            float delta = _buffer[i] * 100 * sin(DEGREES_TO_RADIANS(a) * 8 + t);
            r = radius + circleOffset + delta;
            float offset = sin(DEGREES_TO_RADIANS(a) * 6 + t) * 2;
            float cx = frame.size.width/2 + r * cos(a * M_PI / 180) + offset;
            float cy = frame.size.height/2 + r * sin(a * M_PI / 180) + offset;
            if (i == 0) CGContextMoveToPoint(ctx, cx, cy);
            
            if (SEGMENTED) {
                if ((a + t) % 3 == 0) {
                    CGContextAddEllipseInRect(ctx, CGRectMake(cx - 1 - offset/2, cy - 1 - offset/2, 2 + offset, 2 + offset));
                    CGContextFillPath(ctx);
                }
            } else {
                CGContextAddLineToPoint(ctx, cx, cy);
            }
            
          
        }
    }
    
    if (!SEGMENTED) {
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }

    CGContextRestoreGState(ctx);
    
    // outer circle
    
//    CGContextBeginPath(ctx);
//    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f + circleOffset, 0, 2*M_PI, 0);
//    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
//    CGContextSetLineWidth(ctx, 6.0f);
//    CGContextStrokePath(ctx);
//
//    CGContextBeginPath(ctx);
//    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f + circleOffset, -M_PI_2 + startAngle, [self getAnglePercent], 0);
//    CGContextSetStrokeColorWithColor(ctx, self.fillColor.CGColor);
//    CGContextSetLineWidth(ctx, 4.0f);
//    CGContextStrokePath(ctx);
//    
    // inner circle
    //    CGContextBeginPath(ctx);
    //    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f - 16 , 0, 2*M_PI, 0);
    //    CGContextSetStrokeColorWithColor(ctx, RgbaColor(255, 255, 255, 0.3f).CGColor);
    //    CGContextSetLineWidth(ctx, 3.0f);
    //    CGContextStrokePath(ctx);
    
    // bg
//    CGContextBeginPath(ctx);
//    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f - 18 , 0, 2*M_PI, 0);
//    CGContextSetFillColorWithColor(ctx, RgbColorAlpha(255, 255, 255, 0.6f).CGColor);
//    CGContextFillPath(ctx);
    
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
        
        circleOffset -= 0.05f;
        
    }
}

- (void)updateWithBuffer:(float **)buffer bufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    float* channel = buffer[0];
    
    _buffer = buffer[0];
    _bufferSize = bufferSize;
    
    CGFloat max = 0.0;
    for (int i = 0 ; i < bufferSize ; ++i) {
        if (*(channel+i) > max && *(channel+i) < .1f) max = *(channel+i);
    }
    
    lastValue = max;
}

@end

