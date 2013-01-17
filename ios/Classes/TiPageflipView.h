/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#ifndef __IPHONE_5_0
#define __IPHONE_5_0     50000
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TiModule.h"
#import "TiUtils.h"
#import "TiUIView.h"
#import "KrollCallback.h"
#import "PageFlipper.h"
#import "AdvancedPageFlipperPage.h"
#import "Source.h"
#import "PDFSource.h"
#import "ViewSource.h"
#import "PDFRenderer.h"
#import "FlipTransition.h"
#import "FadeTransition.h"
#import "SlideTransition.h"

@interface TiPageflipView : TiUIView<AFKPageFlipperDelegate
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
, UIPageViewControllerDelegate, UIPageViewControllerDataSource
#endif
>
{
	PageFlipper* flipper;
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    UIPageViewController* advancedFlipper;
    #endif
    NSObject<Source>* source;
    bool landscapeShowsTwoPages;
    bool inLandscape;
    float transitionDuration;
    bool viewAlreadyCreated;
    int currentPage;
    int curlRefreshAnimation;
}

-(void)createView;

-(void)insertPageAfter:(id)args;
-(void)insertPageBefore:(id)args;
-(void)appendPage:(id)args;
-(void)deletePage:(id)args;

-(void)changeCurrentPage:(id)args;

@end
