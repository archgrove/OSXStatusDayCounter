//
//  AppDelegate.h
//  MenuDayCounter
//
//  Created by Adam Wright on 24/09/2012.
//  Copyright (c) 2012 Adam Wright. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSUserDefaults *defaults;
    NSStatusItem *statusItem;
    NSTimer *updateTimer;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSDatePicker *datePicker;
@property (weak) IBOutlet NSButton *doneButton;

@property (weak) IBOutlet NSMenu *menuBarMenu;

- (IBAction)changeDateSelected:(id)sender;
- (IBAction)doneSelected:(id)sender;
@end
