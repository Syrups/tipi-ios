//
//  TPLetterSpacingLabel.m
//  Tipi
//
//  Created by Leo on 11/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPLetterSpacingLabel.h"

@implementation TPLetterSpacingLabel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        
        [attributedString addAttribute:NSKernAttributeName
                                 value:@(kButtonLetterSpacing)
                                 range:NSMakeRange(0, [self.text length])];
        
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 2;
        style.alignment = NSTextAlignmentCenter;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [self.text length])];
        
        self.attributedText = attributedString;
    }
    
    return self;
}

@end
