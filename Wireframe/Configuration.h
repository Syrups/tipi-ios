//
//  Configuration.h
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#ifndef Wireframe_Configuration_h
#define Wireframe_Configuration_h

#define kApiRootUrl @"http://shelter-dev.herokuapp.com/api/v1"

#define kApiTestUserToken @"bf4d45e51878831054e37991d16860ac991a2e7668b7c7011f994ead021118f8"

#define kSessionStoreId    @"user.id"
#define kSessionStoreToken @"user.token"


#define ErrorAlert(msg) UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]; \
[alert show];

#endif
