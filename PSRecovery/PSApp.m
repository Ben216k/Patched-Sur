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
    
//    let process = Process()
//
////    if #available(OSX 10.13, *) {
////        process.executableURL = URL(string: "file://" + binary)
////    } else {
//        // Fallback on earlier versions
//        process.launchPath = binary
////    }
//
//    process.arguments = arguments
//
//    let pipe = Pipe()
//    process.standardOutput = pipe
//    process.standardError = pipe
//    process.launch()
//    process.waitUntilExit()
//
//    let data = pipe.fileHandleForReading.readDataToEndOfFile()
//
//    if let output = String(data: data, encoding: String.Encoding.utf8), !output.isEmpty {
//        process.terminate()
//        return (output, Int(process.terminationStatus))
//    }
//
//    return ("", 0)
}

@end
