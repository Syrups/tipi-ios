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
    //NSTimer* appearanceTimer;
    //NSTimer* closingTimer;
    CGFloat lastValue;
    float* _buffer;
    UInt32 _bufferSize;
    //UInt32 t;
}

static CGFloat const kBaseTime = 0.0f;
static CGFloat const kBaseDuration = 60;
static CGFloat const kBaseRadiusFactor = 0.1;
static CGFloat const kEndRadiusFactor = 1;
static NSTimeInterval const kRadiusFactorUpdateInterval = 0.0005f;
static NSTimeInterval const kAngleFactorUpdateInterval = 0.0005f;

static CGFloat const kRadiusFactorUpdateValue = 0.05;

static CGFloat const kWaveIdleAmplitude = .1f;
static CGFloat const kWaveFrequency = 2.5;

static CGFloat const kArcLineWidth = 4.0f;
static CGFloat const kSliderStroke = kArcLineWidth * 1.9;


static NSTimeInterval const kSyncWithTimeUpdateInterval = 0.005f;


- (id) initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self baseInit];
        [self baseViewInitWithFrame:frame];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.simplePlayer  && [keyPath isEqualToString:@"status"]) {
        if (self.simplePlayer .status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (self.simplePlayer.status == AVPlayerStatusReadyToPlay && self.autoStart) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self.simplePlayer  play];
            
            
        } else if (self.simplePlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}


- (void)setMode:(TPCircleMode)mode{
    _mode = mode;
}

-(void)setMicrophone:(EZMicrophone *)microphone{
    _microphone = microphone;
    _mode = TPCircleModeRecord;
    [self startUpdate];
}

/*
 - (void)setRecorder:(EZRecorder *)recorder{
 _recorder = recorder;
 _mode = TPCircleModeRecord;
 }*/

- (void)setAudioPlayer:(AVAudioPlayer *)audioPlayer{
    _audioPlayer = audioPlayer;
    _duration = _audioPlayer.duration;
    [self startUpdate];
}

- (void)setSimplePlayer:(AVPlayer *)simplePlayer{
    
    if (_simplePlayer != nil){
        [_simplePlayer removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[_simplePlayer currentItem]];
    }
    
    _simplePlayer = simplePlayer;
    _duration = simplePlayer.currentItem.duration.value;
    [_simplePlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(simplerPlayerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_simplePlayer currentItem]];
    
    [self startUpdate];
}

- (void)simplerPlayerItemDidReachEnd:(NSNotification *)notification {
    if(self.delegate && [self.delegate respondsToSelector:@selector(circleWaverControl:didEndPlayingItem:)]){
        [self.delegate circleWaverControl:self didEndPlayingItem:self.simplePlayer.currentItem];
    }
}

- (void)baseInitWithbaseView:(UIView *)baseView {
    [self baseInit];
}

- (void)baseInit{
    
    self.currentBackAngle = ToRad(0);
    self.duration = kBaseDuration;
    self.recordDuration = kBaseDuration;
    
    self.currentTimePercent = kBaseTime;
    self.radiusFactor = kBaseRadiusFactor;
    self.showController = NO;
    
    self.backgroundPathColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.progressPathColor = [UIColor colorWithWhite:1 alpha:0.7];
    self.mode = TPCircleModeListen;
    
    self.backgroundColor = [UIColor clearColor];
    [self setContentMode:UIViewContentModeRedraw];
    
}

- (void)baseViewInitWithFrame:(CGRect)frame{
    
    CGFloat rectSize = [self rectSizeForCircleWithRadius:self.radius];
    CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
    
    CGRect innerFrame = CGRectMake(center.x - (rectSize/2), center.y - (rectSize/2), rectSize, rectSize);
    
    self.wave = [[SCSiriWaveformView alloc] initWithFrame:innerFrame];
    self.wave.backgroundColor = [UIColor clearColor];
    self.wave.idleAmplitude = kWaveIdleAmplitude;
    self.wave.frequency = kWaveFrequency;
    self.wave.alpha = 0;
    self.wave.userInteractionEnabled = NO;
    [self addSubview:self.wave];
    
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
    
    self.innerInteractionView = [[UIView alloc] initWithFrame:innerFrame];
    self.innerInteractionView.backgroundColor = [UIColor clearColor];
    [self addSubview: self.innerInteractionView];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(passLongPressRecognizer:)];
    longPressRecognizer.minimumPressDuration = .5f;
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passLongTapRecognizer:)];
    
    [self.innerInteractionView addGestureRecognizer:longPressRecognizer];
    [self.innerInteractionView addGestureRecognizer:tapGestureRecognizer];
}

- (void)setShowWave:(BOOL)showWave{
    _showWave = showWave;
    _wave.alpha = _showWave ? 1 : 0;
    
    if(_showWave){
        [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }else{
        [self.waveDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    /*CGFloat rectSize = [self rectSizeForCircleWithRadius:self.radius];
     CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
     CGRect innerFrame = CGRectMake(center.x - (rectSize/2), center.y - (rectSize/2), rectSize, rectSize);
     
     if(_showWave){
     if(!_wave){
     _wave = [[SCSiriWaveformView alloc] initWithFrame:innerFrame];
     _wave.backgroundColor = [UIColor clearColor];
     _wave.idleAmplitude = kWaveIdleAmplitude;
     _wave.frequency = kWaveFrequency;
     _wave.alpha = 0;
     _wave.userInteractionEnabled = NO;
     }
     
     [self addSubview:_wave];
     
     self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
     [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
     }else{
     
     }*/
}

- (void)awakeFromNib{
    [self baseViewInitWithFrame:self.frame];
}


- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    self.radius =  (CGRectGetWidth(rect) * 0.45) * self.radiusFactor;
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Draw Background Path
    
    if (self.disAppearing){
        self.backStartAngle += ((ToRad(359)  - self.backStartAngle) * ToRad(2.5));

        int delta = (int)(self.backStartAngle - ToRad(360));
        //
        NSLog(@"dis %d",  delta);
        
        if(delta > 0){
            //self.currentBackAngle = ToRad(360);
            self.disAppearing = NO;
        }
    }
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.radius,-M_PI_2 + self.backStartAngle, [self getBackAngle], 0);
    //-M_PI_2 + self.currentBackAngle
    CGContextSetStrokeColorWithColor(ctx, self.backgroundPathColor.CGColor);
    CGContextSetLineWidth(ctx, kArcLineWidth * 1.3);
    CGContextStrokePath(ctx);
    
    
    //Draw ForeGround Path
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, self.radius, -M_PI_2 + self.startAngle, [self getAngleRadian], 0);
    CGContextSetStrokeColorWithColor(ctx, self.progressPathColor.CGColor);
    CGContextSetLineWidth(ctx, kArcLineWidth * 0.6);
    CGContextStrokePath(ctx);
    
    //[self drawRoundBorder:ctx];
    
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


-(void) drawRoundBorder:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    
    //I Love shadows
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, [UIColor blackColor].CGColor);
    
    //Get the handle position!
    CGPoint handleCenter =  [self pointFromAngle: [self getAngleDeg]];
    
    //Draw It!
    [[UIColor colorWithWhite:1.0 alpha:0.8]set];
    //CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, kSliderStroke, kSliderStroke));
    CGPathCreateWithRoundedRect(CGRectMake(handleCenter.x, handleCenter.y, kSliderStroke, kSliderStroke), 1, 1, NULL);

    CGContextRestoreGState(ctx);
}

- (CGFloat)getBackAngle{
    
    if(self.appearing){
        self.currentBackAngle  += (ToRad(360) - self.currentBackAngle) * ToRad(2.5) ;
    
        int delta = (int)(self.currentBackAngle - ToRad(360));
        if(delta > 0){
            //self.currentBackAngle = ToRad(360);
            self.appearing = NO;
        }
    }
    
    return -M_PI_2 + self.currentBackAngle;
}

/*
- (CGFloat)getEndAngleForBackGround:(BOOL)forBack {
    if (self.disAppearing){
        if(forBack){
            self.currentBackAngle  += (ToRad(0) - self.currentBackAngle) * ToRad(2.5);
        }else{
            self.currentBackAngle  += (ToRad(0) - self.currentBackAngle) * ToRad(2.5);
        }
    }
}*/

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
    
    CGFloat percentFromAngle = ([self getPercentAtAngle:angle]/ 100);
    CGFloat duration = 0;
    
    if(self.audioPlayer){
        duration = self.audioPlayer.duration;
        
    }else if(self.simplePlayer){
        
        duration = self.simplePlayer.currentItem.duration.value;
    }
    
    return duration * percentFromAngle;
}



#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    
    if(self.mode == TPCircleModeListen){
        [self pauseWithFade:NO];
        [self movehandle:[touch locationInView:self]];
    }
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    if(self.mode == TPCircleModeListen)[self movehandle:[touch locationInView:self]];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    if(self.mode == TPCircleModeListen)[self play];
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
    
    if(self.audioPlayer){
        self.audioPlayer.currentTime = [self getTimeAtAngle:angleFloat];
    }else if(self.simplePlayer){
        [self.simplePlayer seekToTime: CMTimeMake([self getTimeAtAngle:angleFloat], 1)];
    }
    
    //Redraw
    [self setNeedsDisplay];
}


- (void)updateWave {
    
    CGFloat normalizedValue = .1f;
    switch (self.mode) {
        case TPCircleModeListen:
            if(self.audioPlayer && self.audioPlayer.isPlaying){
                [self.audioPlayer updateMeters];
                normalizedValue = pow (10, [self.audioPlayer averagePowerForChannel:0] / 20);
            }
            break;
        case TPCircleModeRecord:
            if((self.microphone) && self.nowRecording){
                //[self.audioPlayer updateMeters];
                normalizedValue = .4f;
                //normalizedValue = pow (10, [self.audioPlayer averagePowerForChannel:0] / 20);
            }
            break;
        default:
            break;
    }
    [self.wave updateWithLevel:normalizedValue];
}

#pragma mark - Appearing and closing animations

- (void)appear {
    self.alpha = 1;
    self.radiusFactor = kEndRadiusFactor;
    self.currentBackAngle = ToRad(0);
    self.backStartAngle = 0;
    
    self.appearing = YES;
    
    [self updateAppearing];
}


- (void)updateAppearing {
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat rectSiez = [self rectSizeForCircleWithRadius:self.radius];
    
    self.innerInteractionView.frame = CGRectMake(center.x - (rectSiez/2), center.y - (rectSiez/2), rectSiez, rectSiez);
    self.wave.frame = self.innerInteractionView.frame;
    
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}


- (void)close {
    _bufferSize = 0;
    _buffer = NULL;
    /*closingTimer = [NSTimer scheduledTimerWithTimeInterval:kRadiusFactorUpdateInterval
                                                    target:self
                                                  selector:@selector(updateClosing)
                                                  userInfo:nil
                                                   repeats:YES];*/
    self.appearing = NO;
    self.disAppearing = YES;
}

- (void)updateClosing {
    self.radiusFactor -= kRadiusFactorUpdateValue;
    
    if (self.radiusFactor <= kBaseRadiusFactor) {
        //[closingTimer invalidate];
        self.alpha = 0;
    }
    
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}

- (void)hide {
    self.radiusFactor = -self.frame.size.width/2 + 30;
    [self setNeedsDisplay];
}

#pragma mark - Timer

- (void)startUpdate {
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kSyncWithTimeUpdateInterval
                                                        target:self
                                                      selector:@selector(updateProgress)
                                                      userInfo:nil
                                                       repeats:YES];
    
    //CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    //[displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    self.nowRecording = YES;
    
    [UIView animateWithDuration:.2f animations:^{
        self.wave.alpha = 1;
    }];
}

-(void) pauseUpdate{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)updateProgress {
    switch (self.mode) {
        case TPCircleModeListen:
            if (self.audioPlayer) {
                self.duration = self.audioPlayer.duration;
                self.currentTimePercent  = ((self.audioPlayer.currentTime / self.duration) * 100);
                
                
                if((self.duration - self.audioPlayer.currentTime) <= 1.2){
                    self.audioPlayer.volume = self.duration - self.audioPlayer.currentTime;
                }
                
            }else if(self.simplePlayer){
                
                AVPlayerItem *currentItem = self.simplePlayer.currentItem;
                
                CMTime duration = currentItem.duration; //total time
                CMTime currentTime = currentItem.currentTime; //playing time
                self.duration = CMTimeGetSeconds(duration);
                self.currentTimePercent  =  ((CMTimeGetSeconds(currentTime)/ self.duration) * 100);
                
                if((self.duration - CMTimeGetSeconds(currentTime)) <= 1.2){
                    self.simplePlayer.volume = self.duration - (CMTimeGetSeconds(currentTime));
                }
            }
            break;
        case TPCircleModeRecord:
            if (self.nowRecording) {
                self.duration = kBaseDuration;
                
                self.currentTimePercent  = ((self.currentRecordTime / self.recordDuration) * 100);
                self.currentRecordTime += kSyncWithTimeUpdateInterval;
                
                //NSLog(@"%f : %f/%f", self.currentTimePercent, self.currentRecordTime, self.duration);
                if (self.currentRecordTime >= kBaseDuration) {
                    //[self stopRecording];
                }
            }
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
    [self setContentMode:UIViewContentModeRedraw];
}


-(void)play{
    
    if(!self.updateTimer)[self startUpdate];
    if(self.audioPlayer)[self.audioPlayer play];
    if(self.simplePlayer)[self.simplePlayer play];
}


- (void)pauseWithFade:(BOOL)fade{
    //[self.updateTimer invalidate];
    self.nowRecording = NO;
    
    [UIView animateWithDuration:.2f animations:^{
        self.wave.alpha = 0;
    }];
    
    if(self.audioPlayer){
        if (fade) {
            [self pauseUpdate];
            [self.audioPlayer fadeOutPause];
        } else {
            [self.audioPlayer pause];
        }
    }
    if(self.simplePlayer)[self.simplePlayer pause];
}

- (void)reset {
    [self.updateTimer invalidate];
    self.nowRecording = NO;
    self.currentTimePercent = 0;
    self.radiusFactor = 1;
    
    [self setNeedsDisplay];
}

- (void)startRecordingWithEZRecorder:(EZRecorder*)recorder andEZMicrophone:(EZMicrophone*)microphone {
    self.microphone = microphone;
    [self.microphone startFetchingAudio];
    self.nowRecording = YES;
}

- (void)startFetchingAudio{
    [self.microphone startFetchingAudio];
    self.nowRecording = YES;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(circleWaverControl:didStartRecordingWithMicrophone:)]){
        [self.delegate circleWaverControl:self didStartRecordingWithMicrophone:self.microphone];
    }
}

- (void)stopRecording {
    [self.microphone stopFetchingAudio];
    
    self.nowRecording = NO;
    self.currentTimePercent = kBaseTime;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(circleWaverControl:didEndRecordingWithMicrophone:)]){
        [self.delegate circleWaverControl:self didEndRecordingWithMicrophone:self.microphone];
    }
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


-(float)distanceWithCenter:(CGPoint)current with:(CGPoint)SCCenter{
    CGFloat dx=current.x-SCCenter.x;
    CGFloat dy=current.y-SCCenter.y;
    
    return sqrt(dx*dx + dy*dy);
}

-(CGFloat)rectSizeForCircleWithRadius:(CGFloat)r{
    return  sqrt(2 * powf(r, 2));
}


#pragma mark - UILongPressGestureRecognizer

- (void)passLongPressRecognizer:(UILongPressGestureRecognizer*)recognizer {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(circleWaverControl:didReceveivedLongPressGestureRecognizer:)]){
        [self.delegate circleWaverControl:self didReceveivedLongPressGestureRecognizer:recognizer];
    }
}

- (void)passLongTapRecognizer:(UITapGestureRecognizer*)recognizer {
    if(self.delegate && [self.delegate respondsToSelector:@selector(circleWaverControl:didReceveivedTapGestureRecognizer:)]){
        [self.delegate circleWaverControl:self didReceveivedTapGestureRecognizer:recognizer];
    }
}


- (CGFloat)linearTweenWithTime:(NSTimeInterval)t startValue:(CGFloat)b changeValue:(CGFloat)c andDuration:(CGFloat)d {
    return (t == d) ? b + c : c * (-pow(2, -10 * t / d) + 1) + b;
}
@end
