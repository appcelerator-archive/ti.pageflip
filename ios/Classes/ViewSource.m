/**
 * Ti.Pageflip Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "ViewSource.h"


@implementation ViewSource


#pragma mark Initialization

-(id)initWithArray:(NSArray*)array andProxy:(TiProxy*)value
{
    if ((self = [super init])) {
        pages = [array mutableCopy];
        TiViewProxy* proxy = (TiViewProxy*)value;
        for (TiViewProxy* page in pages) {
            [page setParent:proxy];
            page.view.alpha = 0;
        }
        [proxy layoutChildren:NO];
    }
    return self;
}

- (void)dealloc {
    [pages release];
    [super dealloc];
}

#pragma mark Data Source

- (NSInteger)numberOfPages
{
    return [pages count];
}

- (UIView*)viewForPage:(NSInteger)page withBounds:(CGRect)bounds
{
    UIView* view = [[pages objectAtIndex:page] view];
    view.alpha = 1;
    if (!CGRectIsNull(bounds)) {
        [view setFrame:bounds];
        [view setNeedsDisplay];
        [view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    }
    return view;
}


# pragma mark Public APIs

-(void)insertPageAfter:(id)args
{
    int index = [TiUtils intValue:[args objectAtIndex:0]];
    if (index < 0 || index >= [pages count])
        return;
	TiViewProxy *page = [[args objectAtIndex:1] retain];
    [pages insertObject:page atIndex:index+1];
}

-(void)insertPageBefore:(id)args
{
    int index = [TiUtils intValue:[args objectAtIndex:0]];
    if (index < 0 || index >= [pages count])
        return;
	TiViewProxy *page = [[args objectAtIndex:1] retain];
    [pages insertObject:page atIndex:index];
}

-(void)appendPage:(id)args
{
    TiViewProxy *page = [[args objectAtIndex:0] retain];
    [pages addObject:page];
}

-(void)deletePage:(id)args
{
    int index = [TiUtils intValue:[args objectAtIndex:0]];
    if (index < 0 || index >= [pages count])
        return;
    [[pages objectAtIndex:index] release];
    [pages removeObjectAtIndex:index];
}


@end
