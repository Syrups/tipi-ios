//
//  AppDelegate.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserController.h"
#import "StoryController.h"
#import "RoomController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSData* deviceToken;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UserController* userController;
@property (strong, nonatomic) StoryController* storyController;
@property (strong, nonatomic) RoomController* roomController;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end

