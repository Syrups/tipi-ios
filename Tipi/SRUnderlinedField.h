//
//  SRUnderlinedField.h
//  Wireframe
//
//  Created by Leo on 07/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRUnderlinedField : UITextField

@property (strong, nonatomic) IBInspectable NSString* placeholderText;
@property (strong, nonatomic) IBInspectable UIColor* placeholderColor;
@property (strong, nonatomic) IBInspectable UIColor* borderColor;

@end
