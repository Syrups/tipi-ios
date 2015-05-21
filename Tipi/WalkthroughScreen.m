//
//  WalkthroughScreen.m
//  Wireframe
//
//  Created by Leo on 29/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WalkthroughScreen.h"
#import "PKAIDecoder.h"

@implementation WalkthroughScreen

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        CGFloat midX = CGRectGetMidX(self.frame);
        CGFloat midY = CGRectGetMidY(self.frame);
        
        UIImageView* wave1 = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 150, midY - 150, 100, 50)];
        [PKAIDecoder builAnimatedImageIn:wave1 fromFile:@"onde_bleu_clair"];
        UIImageView* wave2 = [[UIImageView alloc] initWithFrame:CGRectMake(midX + 80, midY - 70, 100, 50)];
        [PKAIDecoder builAnimatedImageIn:wave2 fromFile:@"onde_bleu"];
        UIImageView* star1 = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 140, midY - 100, 60, 60)];
        [PKAIDecoder builAnimatedImageIn:star1 fromFile:@"star"];
        UIImageView* buddy = [[UIImageView alloc] initWithFrame:self.frame];
        [PKAIDecoder builAnimatedImageIn:buddy fromFile:@"tete"];
        UIImageView* voice = [[UIImageView alloc] initWithFrame:CGRectMake(midX - 130, midY - 60, 100, 40)];
        [PKAIDecoder builAnimatedImageIn:voice fromFile:@"onde_voix"];
        
        [self addSubview:wave1];
        [self addSubview:wave2];
        [self addSubview:star1];
        [self addSubview:buddy];
    }
    return self;
}

@end
