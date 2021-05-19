//
//  PSWelcomeController.m
//  PSRecovery
//
//  Created by Ben Sova on 4/14/21.
//

#import <Cocoa/Cocoa.h>
#import "PSWelcomeController.h"
#import "VIButton.h"
#import "PSApp.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@interface PSWelcomeController ()

@property (strong) IBOutlet NSTextField *titleText;
@property (strong) IBOutlet NSTextField *subTitleText;
@property (strong) IBOutlet NSTextField *sectionText;
@property (strong) IBOutlet NSTextField *descriptionText;
@property (strong) IBOutlet VIButton *continueButton;

@end

@implementation PSWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* psDetails = @"v";
    psDetails = [psDetails stringByAppendingString:[PSApp version]];
    psDetails = [psDetails stringByAppendingString:@" ("];
    psDetails = [psDetails stringByAppendingString:[PSApp build]];
    psDetails = [psDetails stringByAppendingString:@")"];
    
    // MARK: Title and Subtitle
    
    self.titleText = [[NSTextField alloc] initWithFrame:CGRectMake(30, 288, 135, 30)];
    self.titleText.stringValue = @"Patched Sur Recovery";
    [self.titleText setBezeled:FALSE];
    [self.titleText setBordered:FALSE];
    [self.titleText setSelectable:FALSE];
    [self.titleText setFont:[NSFont boldSystemFontOfSize:21.5]];
    self.titleText.drawsBackground = false;
    [self.view addSubview:self.titleText];
    
    self.subTitleText = [[NSTextField alloc] initWithFrame:CGRectMake(30, 276, 159, 15)];
    self.subTitleText.stringValue = @"v0.2.0 (83)";
    [self.subTitleText setBezeled:FALSE];
    [self.subTitleText setBordered:FALSE];
    [self.subTitleText setSelectable:FALSE];
    [self.subTitleText setFont:[NSFont boldSystemFontOfSize:12]];
    self.subTitleText.drawsBackground = false;
    self.subTitleText.textColor = NSColor.secondaryLabelColor;
    [self.view addSubview:self.subTitleText];
    
    self.sectionText = [[NSTextField alloc] initWithFrame:CGRectMake(238, 233, 124, 19)];
    self.sectionText.stringValue = @"Recovery Utility";
    [self.sectionText setBezeled:FALSE];
    [self.sectionText setBordered:FALSE];
    [self.sectionText setSelectable:FALSE];
    [self.sectionText setFont:[NSFont boldSystemFontOfSize:15]];
    self.sectionText.drawsBackground = false;
    [self.view addSubview:self.sectionText];
    
    self.descriptionText = [[NSTextField alloc] initWithFrame:CGRectMake(30, 62, 541, 155)];
    self.descriptionText.stringValue = @"Due to the limits set by your Mac, Patched Sur required you to do a little bit of a weird solution to get the most useful recovery environment, however you're done with the hard part. Patched Sur can now override some of recovery mode's normal behavior, allowing for you to have as much recovery mode, even though Patched Sur was limited when recovery first booted. Clicking Continue will bring you back to what looks like recovery mode, except of course with a couple of Patched Sur extras. Once again, don't worry, everything is smooth sailing and there's no way you can break something without intentionally doing it from here on out.";
    [self.descriptionText setBezeled:FALSE];
    [self.descriptionText setBordered:FALSE];
    [self.descriptionText setSelectable:FALSE];
    [self.descriptionText setFont:[NSFont systemFontOfSize:13]];
    self.descriptionText.alignment = NSTextAlignmentCenter;
    self.descriptionText.drawsBackground = false;
    [self.view addSubview:self.descriptionText];
    
    self.continueButton = [[VIButton alloc] initWithFrame:CGRectMake(239, 46, 122, 25)];
    self.continueButton.buttonText = @"Continue";
    [self.continueButton setAction:@selector(psWelcomeContinue:)];
    [self.view addSubview:self.continueButton];
}

@end

#pragma clang diagnostic pop
