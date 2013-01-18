/**
 * Ti.Pageflip Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPageflipViewProxy.h"
#import "TiPageflipView.h"

@implementation TiPageflipViewProxy

#pragma mark Public API

-(void)viewDidAttach
{
    [(TiPageflipView*)[self view] createView];
}

#ifndef USE_VIEW_FOR_UI_METHOD
	#define USE_VIEW_FOR_UI_METHOD(methodname)\
	-(void)methodname:(id)args\
	{\
		[self makeViewPerformSelector:@selector(methodname:) withObject:args createIfNeeded:YES waitUntilDone:NO];\
	}
#endif
USE_VIEW_FOR_UI_METHOD(insertPageAfter);
USE_VIEW_FOR_UI_METHOD(insertPageBefore);
USE_VIEW_FOR_UI_METHOD(appendPage);
USE_VIEW_FOR_UI_METHOD(deletePage);

USE_VIEW_FOR_UI_METHOD(changeCurrentPage);

@end
