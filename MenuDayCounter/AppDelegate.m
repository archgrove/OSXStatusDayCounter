//
//  AppDelegate.m
//  MenuDayCounter
//
//  Created by Adam Wright on 24/09/2012.
//  Copyright (c) 2012 Adam Wright. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Automatically refresh when the user default changes
    // The date control in the XIB is bound to the keypath targetDate
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self forKeyPath:@"targetDate" options:NSKeyValueObservingOptionNew context:nil];
    
    // Configure a status bar item with variable width
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    
    statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    statusItem.highlightMode = YES;
    statusItem.menu = self.menuBarMenu;
    
    // Update with the initial value
    [self changeStatusItem];
}

- (void)changeStatusItem
{
    NSDate *targetDate = [defaults objectForKey:@"targetDate"];
    
    if (targetDate == nil)
    {
        statusItem.title = @"No target date";
    }
    else
    {
        const int secondsPerDay = 60 * 60 * 24;
        
        // This computes the total number of seconds from now unti then
        NSTimeInterval distance = [targetDate timeIntervalSinceNow];
        int days = distance / secondsPerDay;
        statusItem.title = [NSString stringWithFormat:@"%i days left", days];
    }
}

- (IBAction)changeDateSelected:(id)sender
{
    [self.window makeKeyAndOrderFront:nil];
}

- (IBAction)doneSelected:(id)sender
{
    [self.window orderOut:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self changeStatusItem];
}

@end
