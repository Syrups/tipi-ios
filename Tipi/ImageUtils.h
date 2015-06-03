//
//  ImageUtils.h
//  Wireframe
//
//  Created by Leo on 16/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUtils : NSObject

+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)newSize mirrored:(BOOL)mirrored;
+ (UIColor*)blendWithColor:(UIColor*)color1 andColor:(UIColor*)color2 alpha:(CGFloat)alpha2;

@end
