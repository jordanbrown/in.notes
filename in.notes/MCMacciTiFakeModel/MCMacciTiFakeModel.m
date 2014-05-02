//
//  MCMacciTiFakeModel.m
//  FakeModel
//
//  Created by iC on 4/2/14.
//  Copyright (c) 2014 Mac*Citi, LLC. All rights reserved.
//

#import "MCMacciTiFakeModel.h"

@implementation MCMacciTiFakeModel

+ (instancetype)randomModel
{
    MCMacciTiFakeModel *randomModel = [[MCMacciTiFakeModel alloc]init];
    randomModel.userHandle = [self randomUserHandle];
    randomModel.userName = [self randomUserName];
    randomModel.userThumbnail = [self userThumbnailForUserHandle:randomModel.userHandle];
    randomModel.postText = [self randomPostTextForUserHandle:randomModel.userHandle];
    randomModel.postImage = [self randomPostImage];
    
    return randomModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // ...
    }
    return self;
}

#pragma mark - Random Data

+ (NSString *)randomUserHandle
{
    NSArray *userHandles = @[@"@michael", @"@toby", @"@ryan", @"@dwight", @"@jim"];
    return [userHandles objectAtIndex:arc4random() % [userHandles count]];
}

+ (NSString *)randomUserName
{
    NSArray *userNames = @[@"Michael Scott", @"Toby Flenderson", @"Ryan Howard", @"Dwight Schrute", @"Jim Halpert"];
    return [userNames objectAtIndex:arc4random() % [userNames count]];
}

+ (UIImage *)userThumbnailForUserHandle:(NSString *)userHandle
{
    NSString *cleanHandle = [[userHandle substringFromIndex:1]stringByAppendingString:@"-circle"];;
    return [UIImage imageNamed:cleanHandle];
}

+ (NSString *)randomPostTextForUserHandle:(NSString *)userHandle
{
    NSString *postText = nil;
    if ([userHandle isEqualToString:@"@michael"]) {
        NSArray *michaelsQuotes = @[@"Occasionally I will hit someone with my car. So sue me.",
                                    @"Sometimes i'll start a sentence and I don't even know where it's going. I just hope I find it along the way.",
                                    @"You know what they say. Fool me once, strike one, but fool me twice... strike three.",
                                    @"Would you rather be feared or loved? Easy. Both. I want people to be afraid of how much they love me."];
        postText = [michaelsQuotes objectAtIndex:arc4random() % [michaelsQuotes count]];
    } else if ([userHandle isEqualToString:@"@toby"]) {
        NSArray *tobysQuotes = @[@"I have six roommates, which are better than friends because they have to give you one month's notice before they leave.",
                                 @"I would start at the beginning, but I think I need to go farther back.",
                                 @"Can't you just not look at his feet?",
                                 @"You know but the police could have been out there you know, catching real criminals instead of here searching my stuff.",
                                 @"No, I did not violate an Indian burial ground. In fact I had some good luck recently, Alfredo's Pizza, picked my business card out of the basket, so... uh, I got a week of free pies."];
        postText = [tobysQuotes objectAtIndex:arc4random() % [tobysQuotes count]];
    } else if ([userHandle isEqualToString:@"@ryan"]) {
        NSArray *ryansQuotes = @[@"You have to know how to work this. There is no excuse for this.",
                                 @"If you bring your boss to class it automatically bumps you up a full letter grade. So, I'd be stupid not to do it... right?",
                                 @"He basically is man, he's a regular banking wizard.",
                                 @"Blogs are out but people are texting each other 'no more animals.'",
                                 @"I can get you a tutor if you need..."];
        postText = [ryansQuotes objectAtIndex:arc4random() % [ryansQuotes count]];
    } else if ([userHandle isEqualToString:@"@dwight"]) {
        NSArray *dwightsQuotes = @[@"I am fast. To give you a reference point I am somewhere between a snake and a mongoose… And a panther.",
                                   @"I grew up on a farm. I have seen animals having sex in every position imaginable. Goat on chicken. Chicken on goat. Couple of chickens doing a goat, couple of pigs watching.",
                                   @"In the wild, there is no healthcare. Healthcare is “Oh, I broke my leg!” A lion comes and eats you, you’re dead. Well, I’m not dead, I’m the lion, you’re dead!",
                                   @"I don’t have a lot of experience with vampires, but I have hunted werewolves. I shot one once, but by the time I got to it, it had turned back into my neighbor’s dog.",
                                   @"I saw Wedding Crashers accidentally. I bought a ticket for “Grizzly Man” and went into the wrong theater. After an hour, I figured I was in the wrong theater, but I kept waiting. Cuz that’s the thing about bear attacks… they come when you least expect it."];
        postText = [dwightsQuotes objectAtIndex:arc4random() % [dwightsQuotes count]];
    } else if ([userHandle isEqualToString:@"@jim"]) {
        NSArray *jimsQuotes = @[@"One day Michael came in, complaining about a speed bump, on the highway... I wonder who he ran over then.",
                                @"You know what, Kev, do me a favor. Why don't you close your eyes.",
                                @"Last year my boss, Michael Scott, took a day off because he said he had pneumonia, but really he was leaving early to go to magic camp.",
                                @"We're going to Chuck E. Cheese.",
                                @"Is there something about being a manager that makes you say stupid things?"];
        postText = [jimsQuotes objectAtIndex:arc4random() % [jimsQuotes count]];
    }
    
    return postText;
}

+ (UIImage *)randomPostImage
{
    NSArray *imageNames = @[@"app-store-cropped", @"audir8-cropped", @"phone-cropped", @"theme-one-cropped", @"theme-two-cropped"];
    return [UIImage imageNamed:[imageNames objectAtIndex:arc4random() % [imageNames count]]];
}

@end
