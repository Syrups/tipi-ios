//
//  TPLetterSpacingButton.m
//  Tipi
//
//  Created by Leo on 11/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPLetterSpacingButton.h"

@implementation TPLetterSpacingButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
        
        [attributedString addAttribute:NSKernAttributeName
                                 value:@(kButtonLetterSpacing)
                                 range:NSMakeRange(0, [self.titleLabel.text length])];
        
        [self setAttributedTitle:attributedString forState:UIControlStateNormal];
        
        self.titleLabel.clipsToBounds = NO;
    }
    
    return self;
}

@end
