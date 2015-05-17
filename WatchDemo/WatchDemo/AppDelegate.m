//
//  AppDelegate.m
//  WatchDemo
//
//  Created by Rob Nasby on 5/17/15.
//  Copyright (c) 2015 McMaster-Carr. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationCenterKeys.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Applicaiton Lifecycle

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Requesting permission for push notifications...");
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [UIApplication.sharedApplication registerUserNotificationSettings:settings];
    
    return YES;
}


#pragma mark - Notification Lifecycle

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings
{
    NSLog(@"Registering device for push notifications...");
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    NSLog(@"Remote notification registration successful, bundle identifier: %@, mode: %@, device token: %@",
          [NSBundle.mainBundle bundleIdentifier],
          [self modeString],
          token);
    
    NSDictionary *userInfo = @{REMOTE_NOTIFICATION_TOKEN_RECEIVED_PAYLOAD_TOKEN: [token description]};
    [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_NOTIFICATION_TOKEN_RECEIVED object:self userInfo:userInfo];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Remote notification registration failed: %@", error);
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)notification
  completionHandler:(void(^)())completionHandler
{
    NSLog(@"Received push notification: %@, identifier: %@",
          notification,
          identifier);
    completionHandler();
}


#pragma mark - Helpers

- (NSString *)modeString
{
#if DEBUG
    return @"Development (sandbox)";
#else
    return @"Production";
#endif
}

@end
