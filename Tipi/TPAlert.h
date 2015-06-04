//
//  TPAlert.h
//  Tipi
//
//  Created by Leo on 04/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPAlert : UIView

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) UILabel* label;

+ (TPAlert*)displayOnController:(UIViewController*)controller withMessage:(NSString*)message delegate:(id)delegate;
- (instancetype)initWithFrame:(CGRect)frame andMessage:(NSString*)message;
- (void)show;
- (void)dismiss;

@end

@protocol TPAlertDelegate <NSObject>

- (void)alertDidAknowledge:(TPAlert*)alert;

@end
