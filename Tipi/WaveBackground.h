//
//  WaveBackground.h
//  Wireframe
//
//  Created by Leo on 06/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveBackground : UIView

@property CGFloat growingAmount;
@property IBInspectable BOOL openByDefault;

- (void)appear;
- (void)updateImage:(UIImage *)image;

@end
