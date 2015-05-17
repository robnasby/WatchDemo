//
//  ViewController.m
//  NotificationSender
//
//  Created by Rob Nasby on 5/16/15.
//  Copyright (c) 2015 McMaster-Carr. All rights reserved.
//

#import "ViewController.h"

#define STATUS_MESSAGES_TEXT_VIEW_TAG 22
#define TOKEN_TEXT_VIEW_TAG 12

@interface ViewController ()

@property (weak, nonatomic) UITextView *statusMessagesTextView;
@property (weak, nonatomic) UITextView *tokenTextView;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.statusMessagesTextView = (UITextView *)[self.view viewWithTag:STATUS_MESSAGES_TEXT_VIEW_TAG];
    self.statusMessagesTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.statusMessagesTextView.layer.borderWidth = 1.0;
    self.statusMessagesTextView.layer.cornerRadius = 5.0;

    self.tokenTextView = (UITextView *)[self.view viewWithTag:TOKEN_TEXT_VIEW_TAG];
    self.tokenTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tokenTextView.layer.borderWidth = 1.0;
    self.tokenTextView.layer.cornerRadius = 5.0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (id subview in [self.view subviews]) {
        if ([subview isKindOfClass:[UITextView class]]) {
            UITextView *textView = subview;
            if ([textView isFirstResponder]) {
                [textView resignFirstResponder];
            }
        }
    }
}


#pragma mark - Action Outlets

- (IBAction)sendOrderConfirmationButton_TouchUpInside:(id)sender {
    [self appendStatusMessage:@"Sending order confirmation notification..."];
}

- (IBAction)sendPackageDeliveryButton_TouchUpInside:(id)sender {
    [self appendStatusMessage:@"Sending package delivery notification..."];
}

#pragma mark - Status Message Helpers

- (void)appendStatusMessage:(NSString *)message {
    self.statusMessagesTextView.text = [NSString stringWithFormat:@"%@\n%@",
                                        message,
                                        self.statusMessagesTextView.text];
}

@end
