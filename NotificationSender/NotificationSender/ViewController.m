//
//  ViewController.m
//  NotificationSender
//
//  Created by Rob Nasby on 5/16/15.
//  Copyright (c) 2015 McMaster-Carr. All rights reserved.
//

#import "ViewController.h"

#define TOKEN_TEXT_VIEW_TAG 12

@interface ViewController ()

@property (weak, nonatomic) UITextView *tokenTextView;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];

    self.tokenTextView = (UITextView *)[self.view viewWithTag:TOKEN_TEXT_VIEW_TAG];
    self.tokenTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tokenTextView.layer.borderWidth = 1.0;
    self.tokenTextView.layer.cornerRadius = 5.0;
}


#pragma mark - Action Outlets

- (IBAction)sendOrderConfirmationButton_TouchUpInside:(id)sender {
}

- (IBAction)sendPackageDeliveryButton_TouchUpInside:(id)sender {
}

@end
