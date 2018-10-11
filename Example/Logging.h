@import CocoaLumberjack;

// This class is used to existing ObjC compiler flags to detect if we are in debug or release mode.
// This makes sure that in ObjC we don't waste time printing out debug-level statements when we are in release mode
// Change ddLogLevel to suit your needs (and update LogInitializer.swift too)

#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelInfo;
#endif
