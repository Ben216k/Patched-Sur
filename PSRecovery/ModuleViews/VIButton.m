//
//  VIButton.m
//  PSRecovery
//
//  Created by Ben Sova on 4/15/21.
//

#import <Cocoa/Cocoa.h>
#import "VIButton.h"

@interface VIButton ()

@property (strong) NSColor *buttonColor;
@property (strong) NSColor *textColor;

@property (nonatomic, strong) NSString *buttonText;

@property (strong) NSTextField *backgroundView;
@property (strong) NSTextField *buttonLabel;

@end

@implementation VIButton

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];

    self.buttonText = @"Button";
    
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc]
        initWithRect:self.bounds
        options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
        owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    self.buttonColor = [NSColor colorNamed:@"AccentSelected"];
    self.textColor = [NSColor colorNamed:@"Accent"];
    
    self.backgroundView = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.backgroundView setBezeled:false];
    [self.backgroundView setBordered:false];
    [self.backgroundView setEditable:false];
    [self.backgroundView setSelectable:false];
    self.backgroundView.stringValue = @"";
    self.backgroundView.drawsBackground = true;
    self.backgroundView.backgroundColor = self.buttonColor;
    [self addSubview:self.backgroundView];
    
    self.buttonLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 12)];
    [self.buttonLabel setBezeled:false];
    [self.buttonLabel setBordered:false];
    [self.buttonLabel setEditable:false];
    [self.buttonLabel setSelectable:false];
    self.buttonLabel.stringValue = self.buttonText;
    self.buttonLabel.alignment = NSTextAlignmentCenter;
    self.buttonLabel.textColor = self.textColor;
    self.buttonLabel.drawsBackground = false;
    [self addSubview:self.buttonLabel];
    
    self.wantsLayer = true;
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds = true;
    
    self.bezelStyle = NSBezelStyleShadowlessSquare;
    [self setBordered:false];
    self.title = @"";
    
    return self;
}

- (void)viewWillDraw {
    [super viewWillDraw];
    self.buttonLabel.stringValue = self.buttonText;
}

- (void)mouseEntered:(NSEvent *)theEvent{
    [super mouseEntered:theEvent];
    self.buttonColor = [NSColor colorNamed:@"Accent"];
    self.backgroundView.backgroundColor = [NSColor colorNamed:@"Accent"];
    self.textColor = NSColor.whiteColor;
    self.buttonLabel.textColor = NSColor.whiteColor;
    self.needsDisplay = true;
}

- (void)mouseExited:(NSEvent *)theEvent{
    [super mouseExited:theEvent];
    self.buttonColor = [NSColor colorNamed:@"AccentSelected"];
    self.backgroundView.backgroundColor = [NSColor colorNamed:@"AccentSelected"];
    self.textColor = [NSColor colorNamed:@"Accent"];
    self.buttonLabel.textColor = [NSColor colorNamed:@"Accent"];
    self.needsDisplay = true;
}

@end
