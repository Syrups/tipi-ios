//
//  SRAnimatedWaveView.h
//  Wireframe
//
//  Created by Glenn Sonna on 06/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRAnimatedWaveView : UIView

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) CFTimeInterval firstTimestamp;
@property (nonatomic) CFTimeInterval displayLinkTimestamp;
@property (nonatomic) NSUInteger loopCount;

@end
