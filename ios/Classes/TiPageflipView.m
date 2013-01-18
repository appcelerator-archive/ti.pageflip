/**
 * Ti.Pageflip Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiPageflipView.h"

@interface TiPageflipView (Private)

+(BOOL)isIOS5OrGreater;
-(void)useFlipper;
-(void)useAdvancedFlipper;
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
-(UIViewController *)viewControllerAtIndex:(NSUInteger)index;
-(NSUInteger)indexOfViewController:(UIViewController *)viewController;
#endif
- (void)refreshCurrentPage;

@end

@implementation TiPageflipView

#pragma mark Initialization and Memory Management

-(id)init
{
    if ((self = [super init]))
    {
        currentPage = -1;
        transitionDuration = 0.5;
        [self useFlipper];
        landscapeShowsTwoPages = YES;
        [[self proxy] setValue:NUMBOOL(YES) forKey:@"landscapeShowsTwoPages"];
        [[self proxy] setValue:PageflipTransitionFlip forKey:@"transition"];
        [[self proxy] setValue:NUMBOOL(YES) forKey:@"enableBuiltInGestures"];
    }
    return self;
}

-(void)dealloc
{
    RELEASE_TO_NIL(flipper);
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    RELEASE_TO_NIL(advancedFlipper);
    #endif
    RELEASE_TO_NIL(source);
    [super dealloc];
}

#pragma mark Utility Methods

-(BOOL)isLandscape
{
    return self.bounds.size.width > self.bounds.size.height;
}

+(BOOL)isIOS5OrGreater
{
    return [UIAlertView instancesRespondToSelector:@selector(alertViewStyle)];
}

-(void)useFlipper
{
    RELEASE_TO_NIL(flipper);
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    RELEASE_TO_NIL(advancedFlipper);
    #endif
    
    flipper = [[PageFlipper alloc] initWithFrame:[self bounds]];
    flipper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    flipper.flipperDelegate = self;
    flipper.transitionDuration = transitionDuration;
    
    if (source != nil) {
        flipper.dataSource = source;
    }
    
    if (viewAlreadyCreated)
    {
        [self addSubview:flipper];
    }
}

-(void)useAdvancedFlipper
{
    RELEASE_TO_NIL(flipper);
 
    // TODO: Move the bulk of the advanced flipper's logic in to its class, and out of here.
    
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    if (advancedFlipper != nil) {
        if (viewAlreadyCreated) {
            [advancedFlipper.view removeFromSuperview];
        }
        [advancedFlipper release];
    }
    
    int spineLocation = landscapeShowsTwoPages && inLandscape ? UIPageViewControllerSpineLocationMid : UIPageViewControllerSpineLocationMin;
    
    NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:spineLocation]
                                                        forKey:UIPageViewControllerOptionSpineLocationKey];
    
    advancedFlipper = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:options];
    
    advancedFlipper.delegate = self;
    advancedFlipper.dataSource = self;
    
    if (viewAlreadyCreated)
    {
        if (currentPage == -1)
            currentPage = 0;
        [self addSubview:advancedFlipper.view];
        curlRefreshAnimation = UIPageViewControllerNavigationDirectionForward;
        [self refreshCurrentPage];
    }
    #endif
}

#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{   
    // Return the data view controller for the given index.
    int pageCount = [source numberOfPages];
    
    if (index == pageCount && index%2 == 1 && landscapeShowsTwoPages && [self isLandscape]) {
        return [[[AdvancedPageFlipperEmptyPage alloc] init] autorelease];
    }
    
    if (pageCount == 0 || index >= pageCount) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    AdvancedPageFlipperPage *dataViewController = [[AdvancedPageFlipperPage alloc] init];
    dataViewController.index = index;
    dataViewController.enclosedView = [source viewForPage:index withBounds:CGRectNull];
    return [dataViewController autorelease];
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    if ([viewController class] != [AdvancedPageFlipperPage class]) {
        // The only way a non-properly-typed class gets in here is when we intentionally stuffed it in as a bookend view.
        return [source numberOfPages];
    }
    
    return ((AdvancedPageFlipperPage*)viewController).index;
}
#endif

- (void)refreshCurrentPage
{
    if (flipper != nil) {
        [flipper refreshCurrentPage];
    }
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    else if (advancedFlipper != nil) {
        NSArray* pages;
        UIViewController* page = [self viewControllerAtIndex:currentPage];
        if (page == nil) {
            if (currentPage == 0) {
                return;
            }
            page = [self viewControllerAtIndex:currentPage-1];
            if (page == nil) {
                return;
            }
            currentPage = currentPage -1;
            [self pageChanged:currentPage withPageCount:[source numberOfPages]];
        }
        if (inLandscape && landscapeShowsTwoPages) {
            NSUInteger indexOfCurrentViewController = [self indexOfViewController:page];
            if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
                UIViewController *nextApfPage = [self pageViewController:advancedFlipper viewControllerAfterViewController:page];
                if (nextApfPage == nil) {
                    nextApfPage = [[[AdvancedPageFlipperPage alloc] init] autorelease];
                }
                pages = [NSArray arrayWithObjects:page, nextApfPage, nil];
            } else {
                UIViewController *previousApfPage = [self pageViewController:advancedFlipper viewControllerBeforeViewController:page];
                if (previousApfPage == nil) {
                    previousApfPage = [[[AdvancedPageFlipperPage alloc] init] autorelease];
                }
                pages = [NSArray arrayWithObjects:previousApfPage, page, nil];
            }
        }
        else {
            pages = [NSArray arrayWithObject:page];
        }
        [advancedFlipper setViewControllers:pages
                                  direction:curlRefreshAnimation != -1 ? curlRefreshAnimation : UIPageViewControllerNavigationDirectionForward
                                   animated:curlRefreshAnimation != -1
                                 completion:NULL];
        curlRefreshAnimation = -1;
        [self pageChanged:currentPage withPageCount:[source numberOfPages]];
    }
    #endif
}

#pragma mark View Management

-(void)createView
{
    viewAlreadyCreated = YES;
    
    if (flipper != nil) {
        [self addSubview:flipper];
    }
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    else if (advancedFlipper != nil) {
        if (currentPage == -1)
            currentPage = 0;
        [self addSubview:advancedFlipper.view];
        [self refreshCurrentPage];
    }
    #endif
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    if (flipper != nil) {
        [TiUtils setView:flipper positionRect:bounds];
    }
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    else if (advancedFlipper != nil) {
        bool tempInLandscape = bounds.size.width > bounds.size.height;
        if ((tempInLandscape && !inLandscape) || (!tempInLandscape && inLandscape)) {
            inLandscape = tempInLandscape;
            [self useAdvancedFlipper];
        }
        advancedFlipper.view.frame = bounds;
    }
    #endif
}

#pragma mark Public Properties

-(void)setPages_:(id)args
{
    ENSURE_TYPE_OR_NIL(args, NSArray);
    
    if (source != nil)
        RELEASE_TO_NIL(source);
    
    if (args == nil)
        return;
    
    source = [[ViewSource alloc] initWithArray:args andProxy:self.proxy];
    
    if (flipper != nil) {
        flipper.dataSource = source;
    }
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    else if (advancedFlipper != nil) {
        // the advanced flipper tracks with the TiPageflipView's pointer at the source
    }
    #endif
    
    [self refreshCurrentPage];
}

-(void)setPdf_:(id)args
{
    ENSURE_TYPE_OR_NIL(args, NSString);
    
    if (source != nil)
        RELEASE_TO_NIL(source);
    
    if (args == nil)
        return;
    
    NSURL* url = [TiUtils toURL:args proxy:self.proxy];
    source = [[PDFSource alloc] initWithURL:url andProxy:self.proxy];
    
    if (flipper != nil) {
        flipper.dataSource = source;
    }
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    else if (advancedFlipper != nil) {
        // the advanced flipper tracks with the TiPageflipView's pointer at the source
    }
    #endif
    
    [self refreshCurrentPage];
}

-(void)setTransitionDuration_:(id)args
{
    transitionDuration = [TiUtils floatValue:args];
    
    if (flipper != nil) {
        flipper.transitionDuration = transitionDuration;
    }
    else {
        NSLog(@"[WARN] The transition you are using does not support transitionDurations!");
    }
}

-(void)setPagingMarginWidth_:(id)args
{
    if (flipper != nil) {
        flipper.pagingMarginWidth = [TiUtils dimensionValue:args];
    }
    else {
        NSLog(@"[WARN] The transition you are using does not support pagingMarginWidth!");
    }
}

-(void)setLandscapeShowsTwoPages_:(id)args
{
    landscapeShowsTwoPages = [TiUtils boolValue:args];
    [self refreshCurrentPage];
}

-(void)changeCurrentPage:(id)args
{
    // If we don't have any pages, ignore the request.
    int pageCount = [source numberOfPages];
    if (pageCount == 0)
    {
        NSLog(@"[WARN] Attempted to set page before specifying a data source (views or pdf) with at least one page; ignoring request.");
        return;
    }
    
    int requestedPage = [TiUtils intValue:[args objectAtIndex:0]];
	bool animated = [args count] > 1 ? [TiUtils boolValue:[args objectAtIndex:1]] : NO;
    
    // Bounds check to make sure we get a valid 0-based index to a page.
    if (requestedPage < 0)
    {
        NSLog(@"[WARN] Attempted to set currentPage to %d, which is less than zero! Setting to first page instead.", requestedPage);
        [[self proxy] setValue:0 forKey:@"currentPage"];
        return;
    }
    if (requestedPage >= pageCount)
    {
        NSLog(@"[WARN] Attempted to set currentPage to %d, which is above the total number of pages! Setting to last page instead.", requestedPage);
        [[self proxy] setValue:NUMINT(pageCount-1) forKey:@"currentPage"];
        return;
    }
    if (requestedPage == currentPage) {
        NSLog(@"[WARN] Attempted to set currentPage to itself! Ignoring.", requestedPage);
        return;
    }
    
    
    if (flipper != nil) {
        [flipper setCurrentPage:requestedPage animated:animated];
    }
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    else if (advancedFlipper != nil) {
        if (animated) {
            curlRefreshAnimation = requestedPage > currentPage ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        }
        currentPage = requestedPage;
        [self performSelectorOnMainThread:@selector(refreshCurrentPage) withObject:nil waitUntilDone:NO];
    }
    #endif
}

-(void)setTransition_:(id)args
{
    int value = [TiUtils intValue:args];
    switch (value) {
            
        case PageflipTransitionCurl:
            if (![TiPageflipView isIOS5OrGreater]) {
                NSLog(@"[ERROR] The CURL Transition requires iOS 5 or higher! Falling back to FLIP instead.");
                [self useFlipper];
                flipper.transition = [[FlipTransition alloc] init];
            }
            else {
                #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                [self useAdvancedFlipper];
                #else
                NSLog(@"[ERROR] Project compiled with a Base SDK less than iOS5! This transition is not available!");
                [self useFlipper];
                flipper.transition = [[FlipTransition alloc] init];
                #endif
            }
            break;
            
        case PageflipTransitionFade:
            [self useFlipper];
            flipper.transition = [[FadeTransition alloc] init];
            break;
            
        case PageflipTransitionSlide:
            [self useFlipper];
            flipper.transition = [[SlideTransition alloc] init];
            break;
            
        case PageflipTransitionFlip:
        default:
            [self useFlipper];
            flipper.transition = [[FlipTransition alloc] init];
            break;
            
    }
}

-(void)setEnableBuiltInGestures_:(id)args
{
    bool enabled = [TiUtils boolValue:args];
    if (flipper != nil) {
        flipper.disabled = !enabled;        
    }
    #if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    else if (advancedFlipper != nil) {
        for (UIGestureRecognizer *recognizer in advancedFlipper.gestureRecognizers) {
            recognizer.enabled = enabled;
        }
    }
    #endif
}

# pragma mark Public Methods

-(void)insertPageAfter:(id)args
{
    [source insertPageAfter:args];
    [self refreshCurrentPage];
}

-(void)insertPageBefore:(id)args
{
    [source insertPageBefore:args];
    [self refreshCurrentPage];
}

-(void)appendPage:(id)args
{
    [source appendPage:args];
    [self refreshCurrentPage];
}

-(void)deletePage:(id)args
{
    [source deletePage:args];
    [self refreshCurrentPage];
}

#pragma mark Page Flipper Delegate

- (void)pageChanged:(NSInteger)page withPageCount:(NSInteger)pageCount
{
    currentPage = page;
    NSNumber* cp = [NSNumber numberWithInteger:currentPage];
    NSNumber* pc = [NSNumber numberWithInteger:pageCount];
    
    [[self proxy] setValue:cp forKey:@"currentPage"];
    [[self proxy] setValue:pc forKey:@"pageCount"];
    
    NSDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:
                           cp,@"currentPage", pc,@"pageCount", nil];
    [[self proxy] fireEvent:@"change" withObject:event];
}

- (void)pageTapped:(NSInteger)page
{
    currentPage = page;
    NSNumber* cp = [NSNumber numberWithInteger:currentPage];
    NSDictionary* event = [NSDictionary dictionaryWithObjectsAndKeys:
                           cp,@"currentPage", nil];
    [[self proxy] fireEvent:@"tap" withObject:event];
}

- (void)transitionStarted
{
    [self.proxy fireEvent:@"flipStarted"];
}

#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
#pragma mark - UIPageViewController Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    AdvancedPageFlipperPage* page = [pageViewController.viewControllers objectAtIndex:0];
    [self pageChanged:page.index withPageCount:[source numberOfPages]];
    currentPage = page.index;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [self indexOfViewController:(AdvancedPageFlipperPage *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    [self transitionStarted];
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(AdvancedPageFlipperPage *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    [self transitionStarted];
    
    index++;
    return [self viewControllerAtIndex:index];
}

#endif

@end
