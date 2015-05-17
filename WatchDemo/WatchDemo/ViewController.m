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


#pragma mark - Action Outlets

- (IBAction)textTokenButton_TouchUpInside:(id)sender
{
    //check if the device can send text messages
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:self.tokenTextView.text];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
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


#pragma mark - MFMessageComposeViewControllerDelegate Handlers

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
            break;
            
        case MessageComposeResultSent:
            break;
            
        default: break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
