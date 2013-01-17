/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPageflipModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiPageflipModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"43c25a5d-6947-45c6-8092-6b573f9d5222";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.pageflip";
}

#pragma mark Properties

MAKE_SYSTEM_PROP(TRANSITION_FLIP, PageflipTransitionFlip);
MAKE_SYSTEM_PROP(TRANSITION_FADE, PageflipTransitionFade);
MAKE_SYSTEM_PROP(TRANSITION_SLIDE, PageflipTransitionSlide);
MAKE_SYSTEM_PROP(TRANSITION_CURL, PageflipTransitionCurl);


@end
