/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "SlideTransition.h"


@implementation SlideTransition


@synthesize direction, transitionDuration;

-(void) setDirection:(PageFlipperDirection)value
{
    flipDirection = value;
}

-(void) startWithCurrent:(UIView*)current toNew:(UIView*)new withView:(UIView*)view
{
    isDirty = true;
    
    currentView = [current retain];
    newView = [new retain];
    
    centerX = view.bounds.size.width / 2;
    centerY = view.bounds.size.height / 2;
    deltaX = view.bounds.size.width * (flipDirection == PageFlipperDirectionLeft ? 1 : -1);
    
    newView.center = CGPointMake(centerX + deltaX, centerY);
    currentView.center = CGPointMake(centerX, centerY);
}

-(float) update:(float)progress animate:(BOOL)animate
{
    float duration = animate ? fabs((newView.center.x - centerX) / deltaX) * transitionDuration : 0;
    
    if (animate) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
    
    newView.center = CGPointMake(centerX + deltaX * (1 - progress), centerY);
    currentView.center = CGPointMake(centerX - deltaX * progress, centerY);
    
    if (animate) {      
        [UIView commitAnimations];
    }
    
    return duration;
    
}

-(void) stop
{
    if (!isDirty)
        return;
    isDirty = false;
    
    if (newView != nil) {
        newView.center = CGPointMake(centerX, centerY);
        [newView release];
    }
    if (currentView != nil) {
        currentView.center = CGPointMake(centerX, centerY);
        [currentView release];
    }
}

@end
