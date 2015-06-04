//
//  TPCircleWaverControl.m
//  Tipi
//
//  Created by Glenn Sonna on 03/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPCircleWaverControl.h"

/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@implementation TPCircleWaverControl{
    NSTimer* appearanceTimer;
    NSTimer* closingTimer;
    CGFloat lastValue;
    float* _buffer;
    UInt32 _bufferSize;
    //UInt32 t;
}

static CGFloat const kBaseTime = 0.0f;
static CGFloat const kBaseDuration = 100;
static CGFloat const kBaseRadiusFactor = 0.1;
static CGFloat const kEndRadiusFactor = 1;
static NSTimeInterval const kRadiusFactorUpdateInterval = 0.005f;
static CGFloat const kRadiusFactorUpdateValue = kRadiusFactorUpdateInterval;

static CGFloat const kWaveIdleAmplitude = .1f;
static CGFloat const kWaveFrequency = 2;

static CGFloat const kArcLineWidth = 4.0f;
static CGFloat const kSliderStroke = kArcLineWidth * 1.9;


static NSTimeInterval const kSyncWithTimeUpdateInterval = 0.005f;


- (id) initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self baseInit];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (id)initWithBaseView:(UIView *)baseView {
    
    if ((self = [super initWithFrame:baseView.frame])) {
        [self baseInitWithbaseView:baseView];
    }
    return self;
}

- (void)setAudioPlayer:(AVAudioPlayer *)audioPlayer{
    _audioPlayer = audioPlayer;
    _duration = _audioPlayer.duration;
    [self start];
}

- (void)baseInitWithbaseView:(UIView *)baseView {
    [self baseInit];
}

- (void)baseInit{
    
    self.duration = kBaseDuration;
    self.currentTimePercent = kBaseTime;
    self.radiusFactor = kBaseRadiusFactor;
    self.showController = NO;
    
    self.backgroundPathColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.progressPathColor = [UIColor colorWithWhite:1 alpha:0.7];
    self.mode = TPCircleModeListen;
    
    self.backgroundColor = [UIColor clearColor];
    [self setContentMode:UIViewContentModeRedraw];
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    CGFloat waveWidth = CGRectGetWidth(self.frame) * 0.5;
    CGFloat waveHeight = CGRectGetHeight(self.frame) * 0.5;
    
    CGRect innerFrame = CGRectMake(center.x - (waveWidth/2), center.y - (waveHeight/2), waveWidth, waveHeight);
    
    self.wave = [[SCSiriWaveformView alloc] initWithFrame:innerFrame];
    self.wave.backgroundColor = [UIColor clearColor];
    self.wave.idleAmplitude = kWaveIdleAmplitude;
    self.wave.frequency = kWaveFrequency;
    self.wave.alpha = 0;
    self.wave.userInteractionEnabled = NO;
    
    [self addSubview:self.wave];

    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    self.radius =  (CGRectGetWidth(rect) * 0.45) * self.radiusFactor;

    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Draw Background Path
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.radius, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, self.backgroundPathColor.CGColor);
    CGContextSetLineWidth(ctx, kArcLineWidth);
    CGContextStrokePath(ctx);
    
    
    //Draw ForeGround Path
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.radius, -M_PI_2 + self.startAngle, [self getAngleRadian], 0);
    CGContextSetStrokeColorWithColor(ctx, self.progressPathColor.CGColor);
    CGContextSetLineWidth(ctx, kArcLineWidth);
    CGContextStrokePath(ctx);
    
    if(self.showController){
        [self drawTheHandle:ctx];
    }
}


-(void) drawTheHandle:(CGContextRef)ctx{
    
    CGContextSaveGState(ctx);
    
    //I Love shadows
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, [UIColor blackColor].CGColor);
    
    //Get the handle position!
    CGPoint handleCenter =  [self pointFromAngle: [self getAngleDeg]];
    
    //Draw It!
    [[UIColor colorWithWhite:1.0 alpha:0.8]set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, kSliderStroke, kSliderStroke));
    
    CGContextRestoreGState(ctx);
}


- (CGFloat)getAngleRadian {
    return [self getAngleRadianAtTime:self.currentTimePercent];
}

- (CGFloat)getAngleDeg {
    return ToDeg([self getAngleRadian]);
}

- (CGFloat)getAngleRadianAtTime:(CGFloat)time {
    CGFloat a = (M_PI*2) * time;
    CGFloat b = (-M_PI_2 + a / 100);
    
    return self.startAngle + b;
}

- (CGFloat)getAngleDegAtTime:(CGFloat)time {
    return ToDeg([self getAngleRadianAtTime:time]);
}

- (CGFloat)getPercentAtAngle:(CGFloat)angle {
    
    CGFloat a = (100 * ToRad(angle));
    CGFloat b = (M_PI*2);
    
    return (a / b) ;
}

- (NSTimeInterval)getTimeAtAngle:(CGFloat)angle {
    return self.audioPlayer.duration * ([self getPercentAtAngle:angle]/ 100);
}


#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    [self pause];
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    [self start];
}

/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    CGFloat angleFloat = floor(currentAngle) + 90;
    if (angleFloat > 360) angleFloat -= 360;
    
    
    CGFloat percent = [self getPercentAtAngle:angleFloat];
    
    self.currentTimePercent = percent;
    self.audioPlayer.currentTime = [self getTimeAtAngle:angleFloat];
    
    //Redraw
    [self setNeedsDisplay];
}


- (void)updateWave {
    
    CGFloat normalizedValue = .1f;
    switch (self.mode) {
        case TPCircleModeListen:
            if(self.audioPlayer){
                normalizedValue = pow (10, [self.audioPlayer averagePowerForChannel:0] / 20);
            }
            break;
        case TPCircleModeRecord:
            normalizedValue = .4f;
            //normalizedValue = pow (10, [self.audioPlayer averagePowerForChannel:0] / 20);
            break;
        default:
            break;
    }
 
    [self.wave updateWithLevel:normalizedValue];
}

#pragma mark - Appearing and closing animations

- (void)appear {
    self.alpha = 1;
    self.radiusFactor = kBaseRadiusFactor;
    
    /*[UIView animateWithDuration:10 animations:^{
        self.radiusFactor = kEndRadiusFactor;
    } completion:^(BOOL finished) {
        self.appeared = YES;
    }];*/
    appearanceTimer = [NSTimer scheduledTimerWithTimeInterval:kRadiusFactorUpdateInterval
                                                       target:self
                                                     selector:@selector(updateAppearing)
                                                     userInfo:nil
                                                      repeats:YES];
     self.appeared = YES;
}


- (void)updateAppearing {
    self.radiusFactor += kRadiusFactorUpdateValue;
    
    if (self.radiusFactor >= kEndRadiusFactor) {
        self.radiusFactor = kEndRadiusFactor;
        [appearanceTimer invalidate];
    }
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}

- (void)close {
    _bufferSize = 0;
    _buffer = NULL;
    closingTimer = [NSTimer scheduledTimerWithTimeInterval:kRadiusFactorUpdateInterval
                                                    target:self
                                                  selector:@selector(updateClosing)
                                                  userInfo:nil
                                                   repeats:YES];
    self.appeared = NO;
}

- (void)updateClosing {
    self.radiusFactor -= kRadiusFactorUpdateValue;
    
    if (self.radiusFactor <= kBaseRadiusFactor) {
        [closingTimer invalidate];
        self.alpha = 0;
    }
    
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}


- (void)hide {
    self.radiusFactor = -self.frame.size.width/2 + 30;
    self.appeared = NO;
    [self setNeedsDisplay];
}

#pragma mark - Timer

- (void)start {
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kSyncWithTimeUpdateInterval
                                             target:self
                                           selector:@selector(updateProgress)
                                           userInfo:nil
                                            repeats:YES];
    
    //CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    //[displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.recording = YES;
    
    [UIView animateWithDuration:.2f animations:^{
        self.wave.alpha = 1;
    }];
    
    if(self.audioPlayer){
        [self.audioPlayer play];
    }
}

- (void)updateProgress {
    if (self.audioPlayer) {
        self.currentTimePercent  = ((self.audioPlayer.currentTime / self.duration) * 100);
    }else if(self.simplePlayer){
        self.currentTimePercent  =  ((self.simplePlayer.currentTime.value / self.duration) * 100);
    }else{
        [self updateTestProgress];
    }
    
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}


- (void)updateTestProgress {
    if (self.recording) {
        
        if (self.duration <= self.currentTimePercent) return;
        
        self.currentTimePercent += kSyncWithTimeUpdateInterval;
    }
}


- (void)updateProgressWithValue:(CGFloat)currentValue {
    
    if (self.recording) {
        
        if (self.duration <= self.currentTimePercent) return;
        
        self.currentTimePercent = currentValue;
        [self setNeedsDisplay];
        [self setContentMode:UIViewContentModeRedraw];
    }
}

- (void)pause {
    [self.updateTimer invalidate];
    self.recording = NO;
    
    [UIView animateWithDuration:.2f animations:^{
        self.wave.alpha = 0;
    }];
    
    if(self.audioPlayer)[self.audioPlayer pause];
    
}

- (void)reset {
    [self.updateTimer invalidate];
    self.recording = NO;
    self.currentTimePercent = 0;
    self.radiusFactor = 1;
    
    [self setNeedsDisplay];
}

#pragma mark - Math -

-(CGPoint)pointFromAngle:(CGFloat)angle{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - kArcLineWidth, self.frame.size.height/2 - kArcLineWidth);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = centerPoint.y + self.radius * sin(ToRad(angle));
    result.x = centerPoint.x + self.radius * cos(ToRad(angle));
    
    return result;
}

//Sourcecode from Apple example clockControl
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}
@end
