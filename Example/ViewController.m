//
//  ViewController.m
//  Example
//
//  Created by Curtis Herbert on 4/27/18.
//  Copyright © 2018 Curtis Herbert. All rights reserved.
//

@import MessageUI;
@import CocoaLumberjack;
#import "ViewController.h"
#import "MFMailComposeViewController+Feedback.h"
#import "Logging.h"

@interface ViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //in order of severity. Change Logging.h and LogInitializer.swift to tweak which of these show up for the App Store
    //the beauty of CocoaLumberjack is you can leave debug messages in and they just get ignored for the app store.
    DDLogVerbose(@"This is an example of a log that will only be seen when doing a Build->Run. App Store won't log this");
    DDLogDebug(@"This is an example of a log that will only be seen when doing a Build->Run. App Store won't log this");
    DDLogInfo(@"This is an example of a log that will show up always");
    DDLogWarn(@"This is an example of a log that will show up always");
    DDLogError(@"This is an example of a log that will show up always");
}

//I did't hook up a button to trigger this, but use your imagination ;)
- (IBAction)sendFeedback:(id)sender
{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailComposeVC = [MFMailComposeViewController mailControllerUsingFeedbackTemplate:@"Feedback for Version %@"];
        mailComposeVC.mailComposeDelegate = self;
        [self presentViewController:mailComposeVC animated:true completion:nil];

    } else {
        UIAlertController *mailAlertController = [UIAlertController alertControllerWithTitle:@"Can't send feedback" message:@"You don't have a mail account set up on this device. You can get in touch at hello@getslopes.com." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [mailAlertController addAction:okAction];
        [self presentViewController:mailAlertController animated:YES completion:nil];
    }
}

#pragma mark - MFMailComposeViewController delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{ }];
}


@end
