//
//  TPTiltingImageView.h
//  Tipi
//
//  Created by Leo on 04/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface TPTiltingImageView : UIView

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) CMMotionManager* motionManager;
@property BOOL enabled;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image;

@end
