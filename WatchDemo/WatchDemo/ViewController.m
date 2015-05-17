//
//  ViewController.m
//  WatchDemo
//
//  Created by Rob Nasby on 5/17/15.
//  Copyright (c) 2015 McMaster-Carr. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationCenterKeys.h"
#import "ViewController.h"

#define TOKEN_TEXT_VIEW_TAG 22

@interface ViewController ()

@property (weak, nonatomic) UITextView *tokenTextView;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self registerForNotifications];
    
    self.tokenTextView = (UITextView *)[self.view viewWithTag:TOKEN_TEXT_VIEW_TAG];
}


#pragma mark - Notification Center Handlers

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedRemoteNotificationToken:)
                                                 name:REMOTE_NOTIFICATION_TOKEN_RECEIVED
                                               object:nil];
}

- (void)receivedRemoteNotificationToken:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *token = [userInfo objectForKey:REMOTE_NOTIFICATION_TOKEN_RECEIVED_PAYLOAD_TOKEN];

    self.tokenTextView.text = token;
}

@end
