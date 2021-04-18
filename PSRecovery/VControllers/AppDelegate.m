//
//  AppDelegate.m
//  PSRecovery
//
//  Created by Ben Sova on 4/14/21.
//

#import "AppDelegate.h"
#import "PSWelcomeController.h"
#import "PSSpringController.h"
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>
#include <unistd.h>

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@property (nonatomic, strong) IBOutlet PSWelcomeController *psWelcomeController;
@property (nonatomic, strong) IBOutlet PSSpringController *psSpringController;

@end

@implementation AppDelegate

// MARK: App Launch

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

#if !DEBUG
    [[NSApplication sharedApplication] hideOtherApplications:nil];
#endif
    
    self.psWelcomeController = [[PSWelcomeController alloc] initWithNibName:@"PSWelcomeController" bundle:nil];
    self.psWelcomeController.view.frame = self.window.contentView.frame;
    [self.window.contentView addSubview:self.psWelcomeController.view];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

// MARK: Animators

- (CATransition *)continueAnimation {
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    [transition setSubtype:kCATransitionFromRight];
    return transition;
}

- (CATransition *)returnAnimation {
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    [transition setSubtype:kCATransitionFromLeft];
    return transition;
}

- (IBAction)psWelcomeContinue:(NSButton *)sender {
    [self.window.contentView setAnimations:[NSDictionary dictionaryWithObject:[self continueAnimation] forKey:@"subviews"]];
    self.psSpringController = [[PSSpringController alloc] initWithNibName:@"PSSpringController" bundle:nil];
//    [self.window.contentView setFrame:CGRectMake(0, 0, 475, 410)];
    [self.psSpringController.view setFrame:CGRectMake(0, 0, 475, 410)];
    [self.window setFrame:CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y, 475, 440) display:true animate:true];
    [[self.window.contentView animator] replaceSubview:self.psWelcomeController.view with:self.psSpringController.view];
    [self.window center];
}

- (IBAction)psLaunchTerminal:(id)sender {
    [self.window close];
    
    NSTask *terminalTask = [[NSTask alloc] init];
    [terminalTask setLaunchPath:@"/System/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal"];
    [terminalTask setStandardOutput:[NSPipe pipe]];
    [terminalTask setStandardInput:[NSPipe pipe]];
    [terminalTask launch];
    [terminalTask waitUntilExit];
    
    NSLog(@"Done.");
    [self.window makeKeyAndOrderFront:nil];
}

@end
