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

@end
