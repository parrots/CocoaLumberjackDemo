import Foundation
import CocoaLumberjack

// This class is used to check the Swift flags (check "Other Swift Flags" in the build settings, you need to add -DDEBUG and -DRELEASE to your own project so you can detect if this is debug or release mode).
// This makes sure that in Swift we don't waste time printing out debug-level statements when we are in release mode
// Change defaultDebugLevel to suit your needs (and update Logging.h too)

class LogInitializer: NSObject {
    override init() {
        super.init()
#if DEBUG
        defaultDebugLevel = DDLogLevel.verbose
#else
        defaultDebugLevel = DDLogLevel.info
#endif
    }
}
