/**
 * Ti.Pageflip Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "FadeTransition.h"


@implementation FadeTransition


@synthesize direction, transitionDuration;

-(void) setDirection:(PageFlipperDirection)value
{
    flipDirection = value;
}

-(void) startWithCurrent:(UIView*)current toNew:(UIView*)new withView:(UIView*)view
{
    currentView = current;
    newView = new;
    
    newView.alpha = 0;
    currentView.alpha = 1;
}

-(float) update:(float)progress animate:(BOOL)animate
{
    float duration = animate ? (1 - newView.alpha) * transitionDuration : 0;
    
    if (animate) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
    
    currentView.alpha = 1 - progress;
    newView.alpha = progress;
    
    if (animate) {      
        [UIView commitAnimations];
    }
    
    return duration;
}

-(void) stop
{
}

@end
