@import Foundation;
@import MessageUI;

// this is a simple helper category to give me a reusable way to trigger the attachments needed when I want someone to send me feedback and include the relevent log data and also some helpful debug info as attachments.

@interface MFMailComposeViewController (Feedback)

+ (instancetype)mailControllerUsingFeedbackTemplate:(NSString *)subjectTemplate;

@end
