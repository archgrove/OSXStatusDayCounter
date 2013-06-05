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
    [self updateStatusItem];
    
    // Setup the update timer
    [self resetUpdateTimer];
    
    // If the user changes the clock, update the status
    [[NSNotificationCenter defaultCenter] addObserverForName:NSSystemClockDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self updateStatusItem];
    }];
    
    // If we wake from sleep, update the status and reset the timer
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserverForName:NSWorkspaceDidWakeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self updateStatusItem];
        [self resetUpdateTimer];
    }];
    
    // If we sleep, cancel the timer
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserverForName:NSWorkspaceWillSleepNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        updateTimer = nil;
    }];
}

- (void)updateStatusItem
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
        int days = (distance / secondsPerDay) + 1;
        
        NSString *menuString = nil;
        if (days > 0)
            menuString = days > 1 ? @"%i days left" : @"%i day left";
        else if (days == 0)
            menuString = @"It's today";
        else
            menuString = days < -1 ? @"%i days ago" : @"%i day ago";
        
        statusItem.title = [NSString stringWithFormat:menuString, abs(days)];
    }
}

- (IBAction)changeDateSelected:(id)sender
{
    // We must be the active application to show our window, which we're not in general
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:self];
}

- (IBAction)doneSelected:(id)sender
{
    [self.window orderOut:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateStatusItem];
}

- (void)updateTimerFired:(id)context
{
    [self updateStatusItem];
    [self resetUpdateTimer];
}

- (void)resetUpdateTimer
{
    // Setup a time interval that spans until 12:00:01 tomorrow
    NSDate *midnight = [NSDate dateWithNaturalLanguageString:@"Midnight tomorrow"];
    NSTimeInterval toWait = [midnight timeIntervalSinceNow];
    toWait += 1;
    
    updateTimer = [NSTimer timerWithTimeInterval:toWait target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:NO];
}

@end
