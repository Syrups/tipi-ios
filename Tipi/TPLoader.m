//
//  TPLoader.m
//  Wireframe
//
//  Created by Leo on 18/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPLoader.h"
#import "PKAIDecoder.h"

@implementation TPLoader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame) - 50, CGRectGetMidY(frame) - 50, 100, 100)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2)];
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.font = [UIFont fontWithName:@"GTWalsheim-Regular" size:16];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.infoLabel];
        
        self.backgroundColor = RgbColorAlpha(0, 0, 0, .6f);
        
        [PKAIDecoder builAnimatedImageIn:self.imageView fromFile:@"loader"];
    }
    return self;
}

- (void)didMoveToSuperview {
    self.alpha = 0;
    self.imageView.transform = CGAffineTransformMakeTranslation(0, 50);
    
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 1;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

@end
