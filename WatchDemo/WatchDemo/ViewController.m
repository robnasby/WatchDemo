//
//  ViewController.m
//  WatchDemo
//
//  Created by Robert Nasby on 5/14/15.
//  Copyright (c) 2015 McMaster-Carr. All rights reserved.
//

#import "ViewController.h"

#define STATUS_MESSAGES_TEXTVIEW_TAG 21

@interface ViewController ()

@property(nonatomic, weak) UITextView *statusMessagesTextView;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.statusMessagesTextView = (UITextView *)[self.view viewWithTag:STATUS_MESSAGES_TEXTVIEW_TAG];
    self.statusMessagesTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.statusMessagesTextView.layer.borderWidth = 1;
}


#pragma mark - Action Outlets

- (IBAction)sendOrderConfirmationNotification_TouchUpInside:(id)sender {
    [self appendStatusMessage:@"Sending an order confirmation notification..."];
    [self submitLocalNotificationWithMessage:@"Your order of 2 packs of hex nuts was received."
                                       title:@"Order Received"
                                      action:@"View Details"
                                       delay:3.0];
}

- (IBAction)sendPackageDeliveryNotification_TouchUpInside:(id)sender {
    [self appendStatusMessage:@"Sending a package delivery notification..."];
    [self submitLocalNotificationWithMessage:@"You order of 3 paint brushes and 2 other items was recieved by Joanna"
                                       title:@"Order Delivered"
                                      action:@"View Details"
                                       delay:5.0];
}

- (IBAction)simulateRapidReordering_TouchUpInside:(id)sender {
    [self appendStatusMessage:@"Simulating a rapid reordering interaction..."];
}


#pragma mark - Notification Helpers

- (void)submitLocalNotificationWithMessage:(NSString *)message
                                     title:(NSString *)title
                                    action:(NSString *)action
                                     delay:(NSTimeInterval)delay {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertTitle = title;
    notification.alertBody = message;
    notification.alertAction = action;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


#pragma mark - Status Message Helpers

- (void)appendStatusMessage:(NSString *)message {
    self.statusMessagesTextView.text = [NSString stringWithFormat:@"%@\n%@",
                                        message,
                                        self.statusMessagesTextView.text];
}

@end
