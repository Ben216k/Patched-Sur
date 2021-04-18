//
//  PSSpringController.m
//  PSRecovery
//
//  Created by Ben Sova on 4/16/21.
//

#import <Cocoa/Cocoa.h>
#import "PSSpringController.h"
#import "VIButton.h"
#import "PSApp.h"

@interface PSSpringController ()

@property (strong) IBOutlet NSTextField *detailsText;
@property (strong) IBOutlet VIButton *continueButton;

@property (strong) IBOutlet NSString *selectedApp;

// AppListButton Install macOS Big Sur IMBS
@property (strong) IBOutlet NSTextField *imbsTitle;
@property (strong) IBOutlet NSTextField *imbsDescription;
@property (strong) IBOutlet NSButton *imbsImage;
@property (strong) IBOutlet NSButton *imbsTouch;
@property (strong) IBOutlet NSTextField *imbsBackground;

// AppListButton Safari SF
@property (strong) IBOutlet NSTextField *sfTitle;
@property (strong) IBOutlet NSTextField *sfDescription;
@property (strong) IBOutlet NSButton *sfImage;
@property (strong) IBOutlet NSButton *sfTouch;
@property (strong) IBOutlet NSTextField *sfBackground;

// AppListButton DiskUtility DU
@property (strong) IBOutlet NSTextField *duTitle;
@property (strong) IBOutlet NSTextField *duDescription;
@property (strong) IBOutlet NSButton *duImage;
@property (strong) IBOutlet NSButton *duTouch;
@property (strong) IBOutlet NSTextField *duBackground;

// AppListButton Patched Sur PS
@property (strong) IBOutlet NSTextField *psTitle;
@property (strong) IBOutlet NSTextField *psDescription;
@property (strong) IBOutlet NSButton *psImage;
@property (strong) IBOutlet NSButton *psTouch;
@property (strong) IBOutlet NSTextField *psBackground;

@end

@implementation PSSpringController

// MARK: Declare View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedApp = @"";

    // MARK: Get App Info
    
    NSString* psDetails = @"Patched Sur Recovery v";
    psDetails = [psDetails stringByAppendingString:[PSApp version]];
    psDetails = [psDetails stringByAppendingString:@" ("];
    psDetails = [psDetails stringByAppendingString:[PSApp build]];
    psDetails = [psDetails stringByAppendingString:@") - macOS "];
    psDetails = [psDetails stringByAppendingString:[PSApp macOS]];
    
    // MARK: Details Text and Continue Button
    
    self.detailsText = [[NSTextField alloc] initWithFrame:CGRectMake(29, 23, 305, 15)];
//    self.detailsText.stringValue = @"Patched Sur Recovery v0.2.0 (82) - macOS 11.2.3";
    self.detailsText.stringValue = psDetails;
    [self.detailsText setBezeled:false];
    [self.detailsText setBordered:false];
    [self.detailsText setSelectable:false];
    [self.detailsText setFont:[NSFont systemFontOfSize:12]];
    self.detailsText.textColor = NSColor.secondaryLabelColor;
    self.detailsText.drawsBackground = false;
    [self.view addSubview:self.detailsText];
    
    self.continueButton = [[VIButton alloc] initWithFrame:CGRectMake(340, 18, 115, 25)];
    self.continueButton.buttonText = @"Continue";
    [self.continueButton setTarget:self];
    [self.continueButton setAction:@selector(launchApp:)];
    [self.view addSubview:self.continueButton];
    
    // MARK: App Buttons - (Re)install macOS Big Sur
    
    self.imbsBackground = [[NSTextField alloc] initWithFrame:CGRectMake(18, 324, 439, 87)];
    [self.imbsBackground setEnabled:false];
    [self.imbsBackground setSelectable:false];
    [self.imbsBackground setBezeled:false];
    self.imbsBackground.backgroundColor = NSColor.quaternaryLabelColor;
    self.imbsBackground.wantsLayer = true;
    self.imbsBackground.layer.cornerRadius = 10;
    self.imbsBackground.layer.masksToBounds = true;
    self.imbsBackground.drawsBackground = false;
    [self.view addSubview:self.imbsBackground];
    
    self.imbsTitle = [[NSTextField alloc] initWithFrame:CGRectMake(121, 369, 303, 16)];
    [self.imbsTitle setBezeled:false];
    [self.imbsTitle setBordered:false];
    [self.imbsTitle setSelectable:false];
    self.imbsTitle.drawsBackground = false;
    self.imbsTitle.stringValue = @"Reinstall macOS Big Sur";
    [self.view addSubview:self.imbsTitle];
    
    self.imbsDescription = [[NSTextField alloc] initWithFrame:CGRectMake(121, 349, 303, 16)];
    [self.imbsDescription setBezeled:false];
    [self.imbsDescription setBordered:false];
    [self.imbsDescription setSelectable:false];
    self.imbsDescription.drawsBackground = false;
    self.imbsDescription.stringValue = @"Install a new copy of macOS Big Sur onto your Mac.";
    self.imbsDescription.textColor = NSColor.secondaryLabelColor;
    [self.view addSubview:self.imbsDescription];
    
    self.imbsImage = [[NSButton alloc] initWithFrame:CGRectMake(37, 335, 66, 66)];
    self.imbsImage.bezelStyle = NSBezelStyleRegularSquare;
    self.imbsImage.title = @"";
    self.imbsImage.image = [NSImage imageNamed:@"InstallOSSur"];
    self.imbsImage.imageScaling = NSImageScaleProportionallyDown;
    [self.imbsImage setBordered:false];
    [self.view addSubview:self.imbsImage];
    
    self.imbsTouch = [[NSButton alloc] initWithFrame:CGRectMake(18, 324, 439, 87)];
    self.imbsTouch.bezelStyle = NSBezelStyleRegularSquare;
    [self.imbsTouch setBordered:false];
    self.imbsTouch.title = @"";
    [self.imbsTouch setTarget:self];
    self.imbsTouch.action = @selector(toggleIMBSBackground:);
    [self.view addSubview:self.imbsTouch];
    
    // MARK: App Buttons - Safari
    
    self.sfBackground = [[NSTextField alloc] initWithFrame:CGRectMake(18, 234, 439, 87)];
    [self.sfBackground setEnabled:false];
    [self.sfBackground setSelectable:false];
    [self.sfBackground setBezeled:false];
    self.sfBackground.backgroundColor = NSColor.quaternaryLabelColor;
    self.sfBackground.wantsLayer = true;
    self.sfBackground.layer.cornerRadius = 10;
    self.sfBackground.layer.masksToBounds = true;
    self.sfBackground.drawsBackground = false;
    [self.view addSubview:self.sfBackground];
    
    self.sfTitle = [[NSTextField alloc] initWithFrame:CGRectMake(121, 280, 303, 16)];
    [self.sfTitle setBezeled:false];
    [self.sfTitle setBordered:false];
    [self.sfTitle setSelectable:false];
    self.sfTitle.drawsBackground = false;
    self.sfTitle.stringValue = @"Safari";
    [self.view addSubview:self.sfTitle];
    
    self.sfDescription = [[NSTextField alloc] initWithFrame:CGRectMake(121, 260, 303, 16)];
    [self.sfDescription setBezeled:false];
    [self.sfDescription setBordered:false];
    [self.sfDescription setSelectable:false];
    self.sfDescription.drawsBackground = false;
    self.sfDescription.stringValue = @"Browse the Internet to get help with your Mac.";
    self.sfDescription.textColor = NSColor.secondaryLabelColor;
    [self.view addSubview:self.sfDescription];
    
    self.sfImage = [[NSButton alloc] initWithFrame:CGRectMake(37, 245, 66, 66)];
    self.sfImage.bezelStyle = NSBezelStyleRegularSquare;
    self.sfImage.title = @"";
    self.sfImage.image = [NSImage imageNamed:@"Safari"];
    self.sfImage.imageScaling = NSImageScaleProportionallyDown;
    [self.sfImage setBordered:false];
    [self.view addSubview:self.sfImage];
    
    self.sfTouch = [[NSButton alloc] initWithFrame:CGRectMake(18, 234, 439, 87)];
    self.sfTouch.bezelStyle = NSBezelStyleRegularSquare;
    [self.sfTouch setBordered:false];
    self.sfTouch.title = @"";
    [self.sfTouch setTarget:self];
    self.sfTouch.action = @selector(toggleSFBackground:);
    [self.view addSubview:self.sfTouch];
    
    // MARK: App Buttons - Disk Utility
    
    self.duBackground = [[NSTextField alloc] initWithFrame:CGRectMake(18, 145, 439, 87)];
    [self.duBackground setEnabled:false];
    [self.duBackground setSelectable:false];
    [self.duBackground setBezeled:false];
    self.duBackground.backgroundColor = NSColor.quaternaryLabelColor;
    self.duBackground.wantsLayer = true;
    self.duBackground.layer.cornerRadius = 10;
    self.duBackground.layer.masksToBounds = true;
    self.duBackground.drawsBackground = false;
    [self.view addSubview:self.duBackground];
    
    self.duTitle = [[NSTextField alloc] initWithFrame:CGRectMake(121, 191, 303, 16)];
    [self.duTitle setBezeled:false];
    [self.duTitle setBordered:false];
    [self.duTitle setSelectable:false];
    self.duTitle.drawsBackground = false;
    self.duTitle.stringValue = @"Disk Utility";
    [self.view addSubview:self.duTitle];
    
    self.duDescription = [[NSTextField alloc] initWithFrame:CGRectMake(121, 171, 303, 16)];
    [self.duDescription setBezeled:false];
    [self.duDescription setBordered:false];
    [self.duDescription setSelectable:false];
    self.duDescription.drawsBackground = false;
    self.duDescription.stringValue = @"Repair or erase a disk using Disk Utility.";
    self.duDescription.textColor = NSColor.secondaryLabelColor;
    [self.view addSubview:self.duDescription];
    
    self.duImage = [[NSButton alloc] initWithFrame:CGRectMake(37, 156, 66, 66)];
    self.duImage.bezelStyle = NSBezelStyleRegularSquare;
    self.duImage.title = @"";
    self.duImage.image = [NSImage imageNamed:@"DiskUtility"];
    self.duImage.imageScaling = NSImageScaleProportionallyDown;
    [self.duImage setBordered:false];
    [self.view addSubview:self.duImage];
    
    self.duTouch = [[NSButton alloc] initWithFrame:CGRectMake(18, 145, 439, 87)];
    self.duTouch.bezelStyle = NSBezelStyleRegularSquare;
    [self.duTouch setBordered:false];
    self.duTouch.title = @"";
    [self.duTouch setTarget:self];
    self.duTouch.action = @selector(toggleDUBackground:);
    [self.view addSubview:self.duTouch];
    
    // MARK: App Buttons - Patch Kexts
    
    self.psBackground = [[NSTextField alloc] initWithFrame:CGRectMake(18, 56, 439, 87)];
    [self.psBackground setEnabled:false];
    [self.psBackground setSelectable:false];
    [self.psBackground setBezeled:false];
    self.psBackground.backgroundColor = NSColor.quaternaryLabelColor;
    self.psBackground.wantsLayer = true;
    self.psBackground.layer.cornerRadius = 10;
    self.psBackground.layer.masksToBounds = true;
    self.psBackground.drawsBackground = false;
    [self.view addSubview:self.psBackground];
    
    self.psTitle = [[NSTextField alloc] initWithFrame:CGRectMake(121, 102, 303, 16)];
    [self.psTitle setBezeled:false];
    [self.psTitle setBordered:false];
    [self.psTitle setSelectable:false];
    self.psTitle.drawsBackground = false;
    self.psTitle.stringValue = @"Patch Kexts";
    [self.view addSubview:self.psTitle];
    
    self.psDescription = [[NSTextField alloc] initWithFrame:CGRectMake(121, 82, 303, 16)];
    [self.psDescription setBezeled:false];
    [self.psDescription setBordered:false];
    [self.psDescription setSelectable:false];
    self.psDescription.drawsBackground = false;
    self.psDescription.stringValue = @"Make stuff like WiFi and USBs work on your Mac.";
    self.psDescription.textColor = NSColor.secondaryLabelColor;
    [self.view addSubview:self.psDescription];
    
    self.psImage = [[NSButton alloc] initWithFrame:CGRectMake(37, 67, 66, 66)];
    self.psImage.bezelStyle = NSBezelStyleRegularSquare;
    self.psImage.title = @"";
    self.psImage.image = [NSImage imageNamed:@"PatchedSurIcon"];
    self.psImage.imageScaling = NSImageScaleProportionallyDown;
    [self.psImage setBordered:false];
    [self.view addSubview:self.psImage];
    
    self.psTouch = [[NSButton alloc] initWithFrame:CGRectMake(18, 56, 439, 87)];
    self.psTouch.bezelStyle = NSBezelStyleRegularSquare;
    [self.psTouch setBordered:false];
    self.psTouch.title = @"";
    [self.psTouch setTarget:self];
    self.psTouch.action = @selector(togglePSBackground:);
    [self.view addSubview:self.psTouch];
}

-(IBAction)launchApp:(id)sender {
    if (![self.selectedApp isEqualToString:@""] || ![self.selectedApp isEqualToString:@"PS"] ) {
        NSLog(@"Called to launch apps.");
        NSWindow *mainWindow = [[NSApplication sharedApplication] mainWindow];
        [mainWindow close];
        
        NSTask *openTask = [[NSTask alloc] init];
        
        if ([self.selectedApp isEqualToString:@"IMBS"]) {
            NSLog(@"Launching Install macOS Big Sur.app");
#if DEBUG
            [openTask setLaunchPath:@"/Applications/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"];
#else
            [openTask setLaunchPath:@"/Install macOS Big Sur.app/Contents/MacOS/InstallAssistant"];
#endif
        } else if ([self.selectedApp isEqualToString:@"SF"]) {
            NSLog(@"Launching Safari.app");
            [openTask setLaunchPath:@"/Applications/Safari.app/Contents/MacOS/Safari"];
        } else if ([self.selectedApp isEqualToString:@"DU"]) {
            NSLog(@"Launching Disk Utility.app");
            [openTask setLaunchPath:@"/System/Applications/Utilities/Disk Utility.app/Contents/MacOS/Disk Utility"];
        } else {
            [openTask setLaunchPath:@"/bin/echo"];
            NSLog(@"Unknown task, launching echo for no reason.");
        }
        [openTask setStandardOutput:[NSPipe pipe]];
        [openTask setStandardInput:[NSPipe pipe]];
        [openTask launch];
        [openTask waitUntilExit];
        
        NSLog(@"Done.");
        [mainWindow makeKeyAndOrderFront:nil];
    }
}

// MARK: Toggle Backgrounds

-(IBAction)toggleIMBSBackground:(id)sender {
    if ([self.selectedApp isEqualToString:@"IMBS"]) {
        self.imbsBackground.drawsBackground = false;
        self.imbsBackground.needsDisplay = true;
        self.selectedApp = @"";
    } else {
        [self disableAllBackgrounds];
        self.imbsBackground.drawsBackground = true;
        self.imbsBackground.needsDisplay = true;
        self.selectedApp = @"IMBS";
    }
}

-(IBAction)toggleSFBackground:(id)sender {
    if ([self.selectedApp isEqualToString:@"SF"]) {
        self.sfBackground.drawsBackground = false;
        self.sfBackground.needsDisplay = true;
        self.selectedApp = @"";
    } else {
        [self disableAllBackgrounds];
        self.sfBackground.drawsBackground = true;
        self.sfBackground.needsDisplay = true;
        self.selectedApp = @"SF";
    }
}

-(IBAction)toggleDUBackground:(id)sender {
    if ([self.selectedApp isEqualToString:@"DU"]) {
        self.duBackground.drawsBackground = false;
        self.duBackground.needsDisplay = true;
        self.selectedApp = @"";
    } else {
        [self disableAllBackgrounds];
        self.duBackground.drawsBackground = true;
        self.duBackground.needsDisplay = true;
        self.selectedApp = @"DU";
    }
}

-(IBAction)togglePSBackground:(id)sender {
    if ([self.selectedApp isEqualToString:@"PS"]) {
        self.psBackground.drawsBackground = false;
        self.psBackground.needsDisplay = true;
        self.selectedApp = @"";
    } else {
        [self disableAllBackgrounds];
        self.psBackground.drawsBackground = true;
        self.psBackground.needsDisplay = true;
        self.selectedApp = @"PS";
    }
}

-(void)disableAllBackgrounds {
    self.imbsBackground.drawsBackground = false;
    self.imbsBackground.needsDisplay = true;
    
    self.sfBackground.drawsBackground = false;
    self.sfBackground.needsDisplay = true;
    
    self.duBackground.drawsBackground = false;
    self.duBackground.needsDisplay = true;
    
    self.psBackground.drawsBackground = false;
    self.psBackground.needsDisplay = true;
}

@end
