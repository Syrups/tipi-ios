//
//  OrganizerWave.m
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "OrganizerWave.h"

@implementation OrganizerWave {
    CAShapeLayer* shapeLayer;
    UIImageView* imageView;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = RgbColorAlpha(43, 75, 122, 1);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
        imageView.alpha = .1f;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:imageView];
    }
    return self;
}

- (void)updateImage:(UIImage *)image {
    
    UIImageView* newImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
    newImageView.contentMode = UIViewContentModeScaleAspectFill;
    newImageView.image = image;
    newImageView.alpha = 0;
    [self addSubview:newImageView];
    
    [UIView animateWithDuration:.2f animations:^{
        imageView.alpha = 0;
        newImageView.alpha = .1f;
        [imageView removeFromSuperview];
        imageView = newImageView;
    }];

}

- (void)drawRect:(CGRect)rect {
    CGPathRef path = [self pathForLayer];
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = CGPathCreateCopy(path);
    //    layer.fillColor = RgbColorAlpha(43, 75, 122, 0).CGColor;
    
    shapeLayer = layer;
    self.layer.mask = layer;
}

- (CGPathRef)pathForLayer {
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    CGFloat o = self.frame.size.height/2;
    
    CGPoint start = CGPointMake(0, o + arc4random_uniform(20));
    CGPoint middle = CGPointMake(self.frame.size.width/2, start.y - 25 + arc4random_uniform(30));
    CGPoint c1 = CGPointMake(CGRectGetMidX(self.frame)/2 - 10 - arc4random_uniform(20), start.y + arc4random_uniform(30) + 20);
    CGPoint c2 = CGPointMake(CGRectGetMidX(self.frame)/2 + 10 + arc4random_uniform(20), start.y - (arc4random_uniform(30) + 20));
    CGPoint c3 = CGPointMake(CGRectGetMidX(self.frame)*1.5 - 10 - arc4random_uniform(20), middle.y );
    CGPoint c4 = CGPointMake(CGRectGetMidX(self.frame)*1.5 + 10 + arc4random_uniform(20), middle.y - (arc4random_uniform(30) + 20));
    CGPoint end = CGPointMake(self.frame.size.width, start.y - 50 + arc4random_uniform(30));
    
    [path moveToPoint:start];
    [path addCurveToPoint:middle controlPoint1:c1 controlPoint2:c2];
    [path addCurveToPoint:end controlPoint1:c3 controlPoint2:c4];
    
    [path addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:start];
    
    return path.CGPath;
}

@end
