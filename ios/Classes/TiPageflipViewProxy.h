/**
 * Ti.Pageflip Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import "TiUtils.h"
#import "TiViewProxy.h"

@interface TiPageflipViewProxy : TiViewProxy
{
}

-(void)insertPageAfter:(id)args;
-(void)insertPageBefore:(id)args;
-(void)appendPage:(id)args;
-(void)deletePage:(id)args;

-(void)changeCurrentPage:(id)args;

@end
