/**
 * Ti.Pageflip Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import "PageFlipper.h"

@interface TiPageflipModule : TiModule
{
}

@property (readonly, nonatomic) NSNumber* TRANSITION_FLIP;
@property (readonly, nonatomic) NSNumber* TRANSITION_SLIDE;
@property (readonly, nonatomic) NSNumber* TRANSITION_FADE;
@property (readonly, nonatomic) NSNumber* TRANSITION_CURL;

@end
