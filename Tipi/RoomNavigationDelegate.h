//
//  CampToRoomNavigationDelegate.h
//  Wireframe
//
//  Created by Glenn Sonna on 18/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>


@interface RoomNavigationDelegate : NSObject<UINavigationControllerDelegate>

@property UIPercentDrivenInteractiveTransition* interactionController;

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;

@end
