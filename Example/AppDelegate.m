//
//  AppDelegate.m
//  Example
//
//  Created by Curtis Herbert on 4/27/18.
//  Copyright © 2018 Curtis Herbert. All rights reserved.
//

@import CocoaLumberjack;
#import "AppDelegate.h"
#import "CrashlyticsLogger.h"
#import "Logging.h"
#import "Example-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    [self initializeLogging];
    
    return YES;
}

- (void)initializeLogging
{
#ifdef DEBUG
    //if we are debugging, make sure we get the normal Xcode console logs
    DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
    [DDLog addLogger:ttyLogger];
#else
    //if we are in the App Store or Test Flight, we want to make sure crashlytics gets the logs
    CrashlyticsLogger *crashlyticsLogger = [CrashlyticsLogger sharedInstance];
    [DDLog addLogger:crashlyticsLogger];

    //and also log to the normal system output log
    DDASLLogger *aslLogger = [DDASLLogger sharedInstance];
    [DDLog addLogger:aslLogger];
#endif

    //regardless, always log to some files on the disk, to persist logs in between runs
    DDFileLogger* fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24 * 7; //one week worth of logs will be kept
    fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
    [DDLog addLogger:fileLogger];

    id logger __unused = [[LogInitializer alloc] init];
}

@end
