/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>

typedef enum {
	PageFlipperDirectionLeft,
	PageFlipperDirectionRight,
} PageFlipperDirection;


@protocol Transition <NSObject>

-(void) startWithCurrent:(UIView*)current toNew:(UIView*)new withView:(UIView*)view;
-(float) update:(float)progress animate:(BOOL)animate;
-(void) stop;

@property (nonatomic, assign) PageFlipperDirection direction;
@property (nonatomic, assign) float transitionDuration;

@end
