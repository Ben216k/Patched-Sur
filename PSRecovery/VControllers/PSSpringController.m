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

@end

@implementation PSSpringController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    [self.detailsText setBezeled:FALSE];
    [self.detailsText setBordered:FALSE];
    [self.detailsText setSelectable:FALSE];
    [self.detailsText setFont:[NSFont systemFontOfSize:12]];
    self.detailsText.textColor = NSColor.secondaryLabelColor;
    self.detailsText.drawsBackground = false;
    [self.view addSubview:self.detailsText];
    
    self.continueButton = [[VIButton alloc] initWithFrame:CGRectMake(340, 18, 115, 25)];
    self.continueButton.buttonText = @"Continue";
//    [self.continueButton setAction:@selector(psWelcomeContinue:)];
    [self.view addSubview:self.continueButton];
    
    // MARK: App Buttons
    
    
}

@end
