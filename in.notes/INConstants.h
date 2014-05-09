//
//  INConstants.h
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#pragma mark - Global

#define IN_ZERO 0
#define IN_DEFAULT_ANIMATION_DURATION 0.3
#define IN_DEFAULT_SPRING_DAMPING 0.8
#define IN_DEFAULT_DELAY 0.5
#define IN_IMAGE_STORE_DEFAULT_JPG_QUALITY 0.7
#define IN_GENERIC_Q "com.macciti.macciTi.genericQ"
#define IN_NOTES_DEFAULT_APP_COLOR [UIColor colorWithRed:0.44 green:0.51 blue:0.6 alpha:1]

static NSString * const kINManagedObjectContextDidDeleteLastItem = @"kINManagedObjectContextDidDeleteLastItem";
static NSString * const kINManagedObjectContextDidAddNewItem = @"kINManagedObjectContextDidAddNewItem";

#pragma mark - Bootstrap Data
static NSString * const kINBootstrappedInitialData = @"INBootstrappedInitialData";
static NSString * const kINBootstrapInitialText = @"This is your first post. Slide left to delete. Tap on the image to preview it.";
static NSString * const kINBootstrapInitialImage = @"intro-image";
static NSString * const kINBootstrapInitialThumbnail = @"intro-image-thumbnail";

static NSString * const kINNotesLogo = @"in-notes-logo";

#pragma mark - INHomeViewController
static NSString * const kINHomeViewController = @"INHomeViewController";

#pragma mark - INComposeViewController
static NSString * const kINComposeViewController = @"INComposeViewController";
static NSString * const kINEditViewController = @"INEditViewController";