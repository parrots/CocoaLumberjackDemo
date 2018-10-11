@import CocoaLumberjack;

#import "MFMailComposeViewController+Feedback.h"
#import "Example-Swift.h"
#import <sys/utsname.h>

@implementation MFMailComposeViewController (Feedback)

+ (instancetype)mailControllerUsingFeedbackTemplate:(NSString *)subjectTemplate
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    [mailComposeVC setSubject:[NSString stringWithFormat:subjectTemplate, appVersion]];
    [mailComposeVC setToRecipients:@[@"hello@getslopes.com"]];
    NSMutableData *errorLogData = [NSMutableData data];

    //get error log data by inspecting CocoaLumberjack for the file-based logger (which should always be there)
    DDFileLogger *fileLogger;
    for (id<DDLogger> logger in DDLog.allLoggers) {
        if ([logger isKindOfClass:[DDFileLogger class]]) {
            fileLogger = logger;
            break;
        }
    }

    //we want to go through all the logs, read them, and combine them into one long string that we can email as a text file
    NSUInteger maximumLogFilesToReturn = MIN(fileLogger.logFileManager.maximumNumberOfLogFiles, 10);
    NSMutableArray *errorLogFiles = [NSMutableArray arrayWithCapacity:maximumLogFilesToReturn];
    NSArray *sortedLogFileInfos = [fileLogger.logFileManager sortedLogFileInfos];
    for (NSInteger i = MIN(sortedLogFileInfos.count, maximumLogFilesToReturn) - 1; i >= 0; i--) {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:i];
        NSData *fileData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
        [errorLogFiles addObject:fileData];
    }

    for (NSData *errorLogFileData in errorLogFiles) {
        [errorLogData appendData:errorLogFileData];
    }
    [mailComposeVC addAttachmentData:errorLogData mimeType:@"text/plain" fileName:@"ErrorLog.txt"];

    //lets add a debug text file with useful information we can use to help the customer
    
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSMutableString *debugInfo = [[NSMutableString alloc] init];
    [debugInfo appendFormat:@"iOS Version: %@\n", osVersion];
    struct utsname systemInfo;
    uname(&systemInfo);
    [debugInfo appendFormat:@"Device: %@\n", [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
    [debugInfo appendFormat:@"App Version: %@\n", appVersion];

    //I commented the below out, but you can see how I'm including CoreLocation permissions, HealthKit permissions, etc in this text attachment

//    [debugInfo appendFormat:@"Sync Device ID: %@\n", SlopesSyncManager.sharedInstance.deviceID];
//    [debugInfo appendFormat:@"Apple Watch Paired: %@\n", [WCSession defaultSession].isPaired ? @"Yes" : @"No"];
//    [debugInfo appendFormat:@"Apple Watch App Installed: %@\n", [WCSession defaultSession].isWatchAppInstalled ? @"Yes" : @"No"];
//    [debugInfo appendFormat:@"Apple Watch Complication Enabled: %@\n", [WCSession defaultSession].isComplicationEnabled ? @"Yes" : @"No"];
//    switch ([CLLocationManager authorizationStatus]) {
//            case kCLAuthorizationStatusAuthorizedWhenInUse:
//            [debugInfo appendString:@"Location Permission: When in Use\n"];
//            break;
//            case kCLAuthorizationStatusAuthorizedAlways:
//            [debugInfo appendString:@"Location Permission: Always\n"];
//            break;
//            case kCLAuthorizationStatusNotDetermined:
//            [debugInfo appendString:@"Location Permission: Not Determined\n"];
//            break;
//            case kCLAuthorizationStatusDenied:
//            [debugInfo appendString:@"Location Permission: Denied\n"];
//            break;
//            case kCLAuthorizationStatusRestricted:
//            [debugInfo appendString:@"Location Permission: Restricted\n"];
//            break;
//    }
//    switch ([PHPhotoLibrary authorizationStatus]) {
//            case PHAuthorizationStatusAuthorized:
//            [debugInfo appendString:@"Photo Permission: Authorized\n"];
//            break;
//            case PHAuthorizationStatusNotDetermined:
//            [debugInfo appendString:@"Photo Permission: Not Determined\n"];
//            break;
//            case PHAuthorizationStatusDenied:
//            [debugInfo appendString:@"Photo Permission: Denied\n"];
//            break;
//            case PHAuthorizationStatusRestricted:
//            [debugInfo appendString:@"Photo Permission: Restricted\n"];
//            break;
//    }
//    HKHealthStore *store = [[HKHealthStore alloc] init];
//    if (HKHealthStore.isHealthDataAvailable) {
//        NSArray *writeTypes = @[[HKWorkoutType workoutType], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]];
//        if (@available(iOS 11.2, *)) {
//            writeTypes = [writeTypes arrayByAddingObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceDownhillSnowSports]];
//        }
//        for (HKSampleType *type in writeTypes) {
//            [debugInfo appendFormat:@"%@ write: %@\n", NSStringFromClass([type class]), [store authorizationStatusForType:type] == HKAuthorizationStatusSharingAuthorized ? @"Yes" : @"No"];
//        }
//        [debugInfo appendFormat:@"HK DownhillSports Share: %@\n", [WCSession defaultSession].isPaired ? @"Yes" : @"No"];
//    }

    [mailComposeVC addAttachmentData:[debugInfo dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:@"DebugInfo.txt"];

    return mailComposeVC;
}

@end
