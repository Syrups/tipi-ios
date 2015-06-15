//
//  TPAlert.m
//  Tipi
//
//  Created by Leo on 04/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPAlert.h"

@implementation TPAlert {
    UIView* popin;
}

+ (TPAlert*)displayOnController:(UIViewController *)controller withMessage:(NSString *)message delegate:(id)delegate {
    TPAlert* alert = [[TPAlert alloc] initWithFrame:controller.view.frame andMessage:message];
    alert.delegate = delegate;
    [controller.view addSubview:alert];
    
    return alert;
}

- (instancetype)initWithFrame:(CGRect)frame andMessage:(NSString *)message
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat w = 260;
        CGFloat h = 160;
        
        popin = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2 - w/2, frame.size.height/2 - h/2, w, h)];
        popin.backgroundColor = [UIColor whiteColor];
        popin.layer.cornerRadius = 10;
        popin.layer.masksToBounds = YES;
        popin.alpha = 0;
        popin.transform = CGAffineTransformMakeScale(.9f, .9f);
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, popin.frame.size.width - 50, popin.frame.size.height - 50)];
        self.label.font = [UIFont fontWithName:@"GTWalsheim-Regular" size:15];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = message;
        self.label.textColor = [UIColor blackColor];
        self.label.numberOfLines = 3;
        
        UIButton* ok = [[UIButton alloc] initWithFrame:CGRectMake(w/2 - 40, h - 60, 80, 40)];
        [ok setTitle:@"OK" forState:UIControlStateNormal];
        ok.backgroundColor = kCreateBackgroundColor;
        [ok.titleLabel setFont:[UIFont fontWithName:@"GTWalsheim-Regular" size:15]];
        ok.layer.cornerRadius = 20;
        ok.layer.masksToBounds = YES;
        
        [ok addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [popin addSubview:self.label];
        [popin addSubview:ok];
        
        [self addSubview:popin];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.label.text];
        
        
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 1.5f;
        style.alignment = NSTextAlignmentCenter;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [self.label.text length])];
        
        self.label.attributedText = attributedString;
        
        self.backgroundColor = RgbColorAlpha(0, 0, 0, .7f);
        
        [UIView animateWithDuration:.2f animations:^{
            popin.transform = CGAffineTransformIdentity;
            popin.alpha = 1;
        }];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    if (!CGRectContainsPoint(popin.frame, location)) {
        [UIView animateWithDuration:.3f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)okButtonClicked {
    if ([self.delegate respondsToSelector:@selector(alertDidAknowledge:)]) {
        [self.delegate alertDidAknowledge:self];
    }
    
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
