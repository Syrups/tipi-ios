//
//  SRUnderlinedField.m
//  Wireframe
//
//  Created by Leo on 07/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SRUnderlinedField.h"

@implementation SRUnderlinedField

- (void)awakeFromNib {
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: self.placeholderColor}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = self.borderColor.CGColor;
    [self.layer addSublayer:bottomBorder];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    //    self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field-username"]];
    self.leftView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftView.frame = CGRectMake(0, 0, 25, self.frame.size.height);
    

}

@end
