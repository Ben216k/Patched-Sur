//
//  PSApp.m
//  PSRecovery
//
//  Created by Ben Sova on 4/16/21.
//

#import <Foundation/Foundation.h>
#import "PSApp.h"

@implementation PSApp

+(NSString*)version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+(NSString*)build {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+(NSString*)macOS {
    NSProcessInfo *pInfo = [NSProcessInfo processInfo];
    NSString *fullVersion = [pInfo operatingSystemVersionString];
    return [[fullVersion componentsSeparatedByString:@" "] objectAtIndex:1];
}

+(NSArray*)runTask:(NSString*)binary arguments:(NSArray<NSString *> * _Nullable)arguments {
    
    // Create Task
    NSTask *openTask = [[NSTask alloc] init];
    
    // Set Arguments
    [openTask setLaunchPath:binary];
    if (arguments) {
        [openTask setArguments:arguments];
    }
    
    // Set Pipes
    NSPipe* outPipe = [NSPipe pipe];
    openTask.standardOutput = outPipe;
    openTask.standardError = outPipe;
    
    // Launch and Finish Task
    [openTask launch];
    [openTask waitUntilExit];

    // Get Output
    NSData* outData = [outPipe.fileHandleForReading readDataToEndOfFile];
    NSString* output = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    int statusCode = [openTask terminationStatus];
    
    if (output) {
        [openTask terminate];
        return [NSArray arrayWithObjects:output, statusCode, nil];
    }
    
    return [NSArray arrayWithObjects:@"", statusCode, nil];
}

@end
