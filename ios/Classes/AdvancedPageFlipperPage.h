/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#ifndef __IPHONE_5_0
#define __IPHONE_5_0     50000
#endif

#import <UIKit/UIKit.h>
#import "TiApp.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0

@interface AdvancedPageFlipperPage : UIViewController {
    UIView* _enclosedView;
}

@property (nonatomic) NSUInteger index;
@property (strong, nonatomic) UIView* enclosedView;

@end

@interface AdvancedPageFlipperEmptyPage : UIViewController
@end

#endif