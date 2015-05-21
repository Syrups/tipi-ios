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
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame) - 50, CGRectGetMidY(frame) - 50, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        self.backgroundColor = RgbColorAlpha(0, 0, 0, .4f);
        
        [PKAIDecoder builAnimatedImageIn:imageView fromFile:@"loader"];
    }
    return self;
}

@end
