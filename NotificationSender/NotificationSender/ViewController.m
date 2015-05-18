//
//  ViewController.m
//  NotificationSender
//
//  Created by Rob Nasby on 5/16/15.
//  Copyright (c) 2015 McMaster-Carr. All rights reserved.
//

#import "NWPusher.h"
#import "NWSecTools.h"
#import "NWSSLConnection.h"
#import "ViewController.h"

#define APNS_DEVELOPMENT_CERTIFICATE_PASSWORD @"McMaster1901"

#define STATUS_MESSAGES_TEXT_VIEW_TAG 22
#define TOKEN_TEXT_VIEW_TAG 12

@interface ViewController ()

@property (strong, nonatomic) NWPusher *pusher;
@property (weak, nonatomic) UITextView *statusMessagesTextView;
@property (strong, nonatomic, readonly) NSString *token;
@property (weak, nonatomic) UITextView *tokenTextView;

@end

@implementation ViewController

#pragma mark - Properties

- (NSString *)token
{
    NSString *token = self.tokenTextView.text;
    
    if (token.length == 0) return nil;

    token = [token stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return token;
}


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

    NSString *token = self.token;
    if (token) {
        [self sendNotificationWithBody:@"We have received your order of 2 electrical enclosures."
                               toToken:token];
    }
}

- (IBAction)sendPackageDeliveryButton_TouchUpInside:(id)sender {
    [self appendStatusMessage:@"Sending package delivery notification..."];
    
    NSString *token = self.token;
    if (token) {
        [self sendNotificationWithBody:@"We have delivered your order of paint brushes and wing nuts to Joanna."
                               toToken:token];
    }
}


#pragma mark - Remote Notification Helpers

- (void)checkStatusUsingPusher:(NWPusher *)pusher
{
    NSUInteger identifier = 0;
    NSError *apnError = nil;
    NSError *error = nil;
    BOOL read = [pusher readFailedIdentifier:&identifier apnError:&apnError error:&error];
    if (read && apnError) {
        NSLog(@"Notification with identifier %i rejected: %@", (int)identifier, apnError);
    } else if (error) {
        NSLog(@"Unable to read failed: %@", error);
    }
}

- (NWPusher *)createPusher
{
    NSURL *url = [NSBundle.mainBundle URLForResource:@"WatchDemo - Push Notification - Development.p12" withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NWPusher *pusher = [NWPusher connectWithPKCS12Data:pkcs12 password:APNS_DEVELOPMENT_CERTIFICATE_PASSWORD error:&error];
    if (pusher) {
        NWCertificateRef certificate = [NWSecTools certificateWithIdentity:pusher.connection.identity error:&error];
        NSLog(@"Connected to APN: %@%@",
              [NWSecTools summaryWithCertificate:certificate],
              [NWSecTools isSandboxCertificate:certificate] ? @" (sandbox)" : @"");
    } else {
        NSLog(@"Unable to connect: %@", error);
    }
    
    return pusher;
}

- (void)sendNotificationWithBody:(NSString *)body
                         toToken:(NSString *)token
{
    NWPusher *pusher = [self createPusher];

    NSDictionary *payload = @{@"aps": @{@"alert": body, @"sound": @"default"}};
    NSString *jsonPayload = [self serializeApnPayload:payload];
    
    NSError *error = nil;
    BOOL pushed = [pusher pushPayload:jsonPayload token:token identifier:rand() error:&error];
    if (pushed) {
        NSLog(@"Pushed to APNs");
    } else {
        NSLog(@"Unable to push: %@", error);
    }
    
    [self performSelector:@selector(checkStatusUsingPusher:) withObject:pusher afterDelay:2.0];
}

- (NSString *)serializeApnPayload:(NSDictionary *)payload
{
    NSString *jsonString = nil;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}


#pragma mark - Status Message Helpers

- (void)appendStatusMessage:(NSString *)message {
    self.statusMessagesTextView.text = [NSString stringWithFormat:@"%@\n%@",
                                        message,
                                        self.statusMessagesTextView.text];
}

@end
