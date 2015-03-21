//
//  BaseManager.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseManager : NSObject

@property (weak, nonatomic) id delegate;

- (id)initWithDelegate:(id)delegate;

@end
