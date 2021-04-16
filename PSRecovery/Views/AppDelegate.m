//
//  AppDelegate.m
//  PSRecovery
//
//  Created by Ben Sova on 4/14/21.
//

#import "AppDelegate.h"
#import "PSWelcomeController.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@property (nonatomic, strong) IBOutlet PSWelcomeController *psWelcomeController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.psWelcomeController = [[PSWelcomeController alloc] initWithNibName:@"PSWelcomeController" bundle:nil];
    self.psWelcomeController.view.frame = self.window.contentView.frame;
    [self.window.contentView addSubview:self.psWelcomeController.view];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
