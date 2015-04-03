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
    CGFloat currentTime;
    CGFloat totalDuration;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    currentTime = 0.0f;
    totalDuration = 30;
    
    self = [super initWithCoder:aDecoder];
    self.backgroundColor = [UIColor clearColor];
    
    [self setContentMode:UIViewContentModeRedraw];
    
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame totalDuration:(CGFloat)total {
    currentTime = 0.0f;
    totalDuration = total;
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    [self setContentMode:UIViewContentModeRedraw];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // outer circle
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f - 11, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, RgbColorAlpha(255, 255, 128, 1).CGColor);
    CGContextSetLineWidth(ctx, 12.0f);
    CGContextStrokePath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.frame.size.width/2.5f - 11, -M_PI_2, [self getAnglePercent], 0);
    CGContextSetStrokeColorWithColor(ctx, RgbColorAlpha(255, 0, 0, 1).CGColor);
    CGContextSetLineWidth(ctx, 12.0f);
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
    return -M_PI_2 + (M_PI*2 * currentTime) / totalDuration;
}

- (void)update {
    
    if (totalDuration <= currentTime) return;
    
    currentTime += 0.05f;
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}

@end

