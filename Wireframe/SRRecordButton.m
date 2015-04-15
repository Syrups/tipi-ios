//
//  SRRecordButton.m
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SRRecordButton.h"
#import "Configuration.h"

@implementation SRRecordButton {
    NSTimer* timer;
    CGFloat circleOffset;
    CGFloat startAngle;
    NSTimer* appearanceTimer;
    NSTimer* closingTimer;
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
    appearanceTimer = [NSTimer scheduledTimerWithTimeInterval:0.005f target:self selector:@selector(updateAppearing) userInfo:nil repeats:YES];
}

- (void)close {
    closingTimer = [NSTimer scheduledTimerWithTimeInterval:0.005f target:self selector:@selector(updateClosing) userInfo:nil repeats:YES];
}

- (void)updateAppearing {
    
    if (self.currentTime >= self.duration) {
        startAngle += .05f;
        
        if (startAngle >= M_2_PI) {
            startAngle = 0;
            self.currentTime = 0;
            [appearanceTimer invalidate];
        }
    } else {
        self.currentTime += .7f;
    }

    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}

- (void)updateClosing {
    circleOffset -= 3.5f;
    
    if (circleOffset <= -self.frame.size.width/2 + 30) {
        [closingTimer invalidate];
    }
    
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}

#pragma mark - Timer

- (void)start {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)pause {
    [timer invalidate];
}

- (void)reset {
    [timer invalidate];
    self.currentTime = 0;
    circleOffset = 10;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // outer circle
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f + circleOffset, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, 8.0f);
    CGContextStrokePath(ctx);

    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f + circleOffset, -M_PI_2 + startAngle, [self getAnglePercent], 0);
    CGContextSetStrokeColorWithColor(ctx, self.fillColor.CGColor);
    CGContextSetLineWidth(ctx, 8.0f);
    CGContextStrokePath(ctx);
    
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
    
    if (self.duration <= self.currentTime) return;
    
    self.currentTime += 0.05f;
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
    
    circleOffset -= 0.05f;
}

@end

