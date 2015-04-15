//
//  AudioWave.h
//  Wireframe
//
//  Created by Leo on 14/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioWave : UIView

@property BOOL deployed;

- (void)hide;
- (void)updateBuffer:(float*)buffer withBufferSize:(UInt32)bufferSize;

@end
