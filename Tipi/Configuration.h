//
//  Configuration.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#ifndef Wireframe_Configuration_h
#define Wireframe_Configuration_h

#import "UserSession.h"

//shelter-dev.herokuapp.com
//localhost:3000
#define kApiRootUrl @"http://52.16.102.93/api/v1"
#define kMediaRootUrl @"http://52.16.102.93/uploads/media/"
#define kAudioRootUrl @"http://52.16.102.93/uploads/audio/"

#define kStoryboardStoryBuilder @"StoryBuilder"
#define kStoryboardRooms        @"Rooms"
#define kStoryboardProfile      @"Profile"

#define kFeedbackEmail @"syrupdev@gmail.com"
#define kButtonLetterSpacing .4f

#define kApiTestUserToken @"bf4d45e51878831054e37991d16860ac991a2e7668b7c7011f994ead021118f8"

#define kSessionStoreId    @"user.id"
#define kSessionStoreToken @"user.token"
#define kCookieCoachmarkKey @"user.coachmark_cookie"

#define kMediaPickerMediaLimit 999999

#define ErrorAlert(msg) UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]; \
[alert show];

#define RgbColorAlpha(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define APP_DELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate];

#define CurrentUser [[UserSession sharedSession] user]

#define SRLog(msg) NSLog([@" [x] " stringByAppendingString:msg])

#define P(x,y) CGPointMake(x,y)

// Colors

//#define kListenBackgroundColor RgbColorAlpha(195, 54, 50, 1)
#define kListenBackgroundColor RgbColorAlpha(207, 89, 61, 1)
//#define kCreateBackgroundColor RgbColorAlpha(31, 47, 82, 1)
#define kCreateBackgroundColor RgbColorAlpha(239, 148, 42, 1)

#endif
