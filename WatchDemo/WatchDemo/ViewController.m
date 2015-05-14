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
}

- (IBAction)sendPackageDeliveryNotification_TouchUpInside:(id)sender {
    [self appendStatusMessage:@"Sending a package delivery notification..."];
}

- (IBAction)simulateRapidReordering_TouchUpInside:(id)sender {
    [self appendStatusMessage:@"Simulating a rapid reordering interaction..."];
}


#pragma mark - Status Message Helpers

- (void)appendStatusMessage:(NSString *)message {
    self.statusMessagesTextView.text = [NSString stringWithFormat:@"%@\n%@",
                                        message,
                                        self.statusMessagesTextView.text];
}

@end
