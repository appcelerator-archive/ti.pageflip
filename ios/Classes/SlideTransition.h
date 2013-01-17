/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Transition.h"


@interface SlideTransition : NSObject<Transition> {
    UIView* currentView;
    UIView* newView;
    
    PageFlipperDirection flipDirection;
    
    float deltaX;
    float centerY;
    float centerX;
    
    bool isDirty;
}

@property (nonatomic, assign) float transitionDuration;

@end
