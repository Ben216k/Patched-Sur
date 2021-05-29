//
//  AuthorizeExecute.m
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 5/25/21.
//

#import <AppKit/AppKit.h>
#import <Security/Security.h>
#import "AuthorizeExecute.h"

@implementation PSApp

-(void)authorizeExecute {
    AuthorizationExecuteWithPrivileges(errAuthorizationInvalidRef, [[NSBundle mainBundle] executablePath], kAuthorizationFlagDefaults, "", [NSPrintingCommunicationException]);
}

@end
