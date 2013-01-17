//
//  AFKPageFlipper.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-12.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "PageFlipper.h"


#pragma mark -
#pragma mark Private interface


@interface PageFlipper()

@property (nonatomic,assign) UIView *currentView;
@property (nonatomic,assign) UIView *nextView;
-(void) reportPageChange;

@end


@implementation PageFlipper


#pragma mark -
#pragma mark Flip functionality


- (void) initFlip {
	[transition startWithCurrent:self.currentView toNew:self.nextView withView:self];
    if([[self flipperDelegate] respondsToSelector:@selector(transitionStarted)]) {
        [[self flipperDelegate] transitionStarted];
    }
}


- (void) cleanupFlip {
    [transition stop];
    
	animating = NO;
	
	if (setNextViewOnCompletion) {
		[self.currentView removeFromSuperview];
        self.currentView.alpha = 1;
		self.currentView = self.nextView;
		self.nextView = Nil;
	} else {
        self.nextView.alpha = 1;
		[self.nextView removeFromSuperview];
		self.nextView = Nil;
	}

	self.currentView.alpha = 1;
    
    [self reportPageChange];
}


- (void) reportPageChange
{
    if([[self flipperDelegate] respondsToSelector:@selector(pageChanged:withPageCount:)]) {
        [[self flipperDelegate] pageChanged:currentPage withPageCount:numberOfPages];
    }
}


- (int) getPagingMarginDelta: (int) width  {
    if (TiDimensionIsUndefined(pagingMarginWidth)) {
        return width * 0.1;
    }
    return TiDimensionCalculateValue(pagingMarginWidth, width);
}


- (void) setFlipProgress:(float) progress setDelegate:(BOOL) setDelegate animate:(BOOL) animate {
    if (animate) {
        animating = YES;
    }
	float duration = [transition update:progress animate:animate];
	if (setDelegate) {
		[self performSelector:@selector(cleanupFlip) withObject:Nil afterDelay:duration];
	}
}


- (void) flipPage {
	[self setFlipProgress:1.0 setDelegate:YES animate:YES];
}


#pragma mark -
#pragma mark Animation management


- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
	[self cleanupFlip];
}


#pragma mark -
#pragma mark Properties

@synthesize currentView;
- (void) setCurrentView:(UIView *) value {
	if (currentView) {
		[currentView release];
	}
	currentView = [value retain];
}

@synthesize nextView;
- (void) setNextView:(UIView *) value {
	if (nextView) {
		[nextView release];
	}
	nextView = [value retain];
}

@synthesize flipperDelegate = flipperDelegate;

@synthesize currentPage = currentPage;
- (BOOL) doSetCurrentPage:(NSInteger) value {
	if (value == currentPage) {
		return FALSE;
	}
    
    if (value < 0 || value > numberOfPages - 1) {
        return FALSE;
    }
    
    // Are we in landscape with two pages showing?
    if ([self isLandscape] && [self landscapeShowsTwoPages]) {
        // Is the user trying to flip us to the other visible page?
        if (value / 2 == currentPage / 2) {
            currentPage = value;
            [self reportPageChange];
            return FALSE;
        }
    }
    
	transition.direction = value < currentPage ? PageFlipperDirectionRight : PageFlipperDirectionLeft;
	
	currentPage = value;
    
	
    if ([self isLandscape] && landscapeShowsTwoPages) {
        UIView* container = [[UIView alloc] initWithFrame:self.bounds];
        
        int leftPage, rightPage;
        if (value % 2 == 0) {
            leftPage = value;
            rightPage = value + 1;
        } else {
            leftPage = value - 1;
            rightPage = value;
        }
        
        
        CGRect rect = self.bounds;
        rect.size.width /= 2;
        
        [container addSubview:[self.dataSource viewForPage:leftPage withBounds:rect]];
        
        if (rightPage < [self.dataSource numberOfPages]) {
            rect.origin.x = rect.size.width;
            [container addSubview:[self.dataSource viewForPage:rightPage withBounds:rect]];
        }
        
        self.nextView = [container autorelease];
    }
    else {
        self.nextView = [self.dataSource viewForPage:value withBounds:self.bounds];
    }
    
	[self addSubview:self.nextView];
	
	return TRUE;
}
- (void) refreshCurrentPage {
    [self.currentView removeFromSuperview];
    [self.nextView removeFromSuperview];
    self.nextView = self.currentView = Nil;
    numberOfPages = [dataSource numberOfPages];
    int temp = MAX(MIN(currentPage, numberOfPages-1), 0);
    currentPage = INT_MIN;
    [self setCurrentPage:temp animated:NO];
}
- (void) setCurrentPage:(NSInteger) value animated:(BOOL) animated {
	if (![self doSetCurrentPage:value]) {
		return;
	}
	setNextViewOnCompletion = YES;
	animating = YES;
	if (animated) {
		[self initFlip];
		[self performSelector:@selector(flipPage) withObject:Nil afterDelay:0.001];
	} else {
		[self animationDidStop:Nil finished:[NSNumber numberWithBool:NO] context:Nil];
	}
}

@synthesize transitionDuration;
-(void)setTransitionDuration:(float)duration
{
    rootTransitionDuration = duration;
    if (transition != nil) {
        transition.transitionDuration = rootTransitionDuration;
    }
}

@synthesize transition;
- (void) setTransition:(NSObject<Transition> *)value {
    if (transition != nil) {
        [transition release];
    }
    transition = [value retain];
    transition.transitionDuration = rootTransitionDuration;
}

@synthesize dataSource;
- (void) setDataSource:(NSObject <AFKPageFlipperDataSource>*) value {
	if (dataSource) {
		[dataSource release];
	}
	dataSource = [value retain];
	numberOfPages = [dataSource numberOfPages];
    currentPage = INT_MIN;
    [self setCurrentPage:0 animated:NO];
}

@synthesize disabled;
- (void) setDisabled:(BOOL) value {
	disabled = value;
	self.userInteractionEnabled = !value;
	for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
		recognizer.enabled = !value;
	}
}

@synthesize pagingMarginWidth;
- (void) setPagingMarginWidth:(TiDimension)value {
    pagingMarginWidth = value;
}


- (BOOL) isLandscape {
    return self.bounds.size.width > self.bounds.size.height;
}

@synthesize landscapeShowsTwoPages;
- (void) landscapeShowsTwoPages:(BOOL) value {
    landscapeShowsTwoPages = value;
}


#pragma mark -
#pragma mark Touch management

/**
 Change the page when the user taps on the left or right of the screen. The width of the hit area is controlled by the "pagingMarginWidth" property.
 */
- (void) tapped:(UITapGestureRecognizer *) recognizer {
	if (recognizer.state == UIGestureRecognizerStateRecognized) {
		NSInteger newPage;
		
        int x = [recognizer locationInView:self].x;
        int width = self.bounds.size.width - self.bounds.origin.x;
        int delta = [self getPagingMarginDelta: width];
        
        int change = landscapeShowsTwoPages && [self isLandscape] ? 2 : 1;
		if (x < delta) {
			newPage = MAX(0, self.currentPage - change);
		} else if (x > width - delta) {
			newPage = MIN(self.currentPage + change, numberOfPages-1);
		} else {
            // NOTE: this will never happen. We explicitly stop processing touches that take place outside of the paging margins.
            return;
        }
		
		[self setCurrentPage:newPage animated:YES];
	}
}

/**
 Change the page when the user starts a pan from the left or right of the screen and drags the page over. The animation is fully
 controlled by the user's pan.  The width of the starting hit area is controlled by the "pagingMarginWidth" property.
 */
- (void) panned:(UIPanGestureRecognizer *) recognizer {
    if (animating) {
        return;
    }
    
	static BOOL hasFailed;
	static BOOL initialized;
	
	static NSInteger oldPage;

	float translation = [recognizer translationInView:self].x;
	float progress = fabs(translation / self.bounds.size.width);
	
	switch (recognizer.state) {
            
        case UIGestureRecognizerStatePossible:
            break;
            
        case UIGestureRecognizerStateCancelled:
            break;
            
		case UIGestureRecognizerStateBegan:
			initialized = FALSE;
            hasFailed = NO;
			animating = NO;
			setNextViewOnCompletion = NO;
            
			break;
            
            
		case UIGestureRecognizerStateChanged:
			
			if (hasFailed) {
				return;
			}
			
			if (!initialized) {
				oldPage = self.currentPage;
				
                int change = (translation > 0 ? -1 : 1) * (landscapeShowsTwoPages && [self isLandscape] ? 2 : 1);
				if (![self doSetCurrentPage:self.currentPage + change]) {
                    hasFailed = YES;
                    return;
                }
				
				hasFailed = NO;
				initialized = YES;
				setNextViewOnCompletion = NO;
				
				[self initFlip];
			}
			
			[self setFlipProgress:fabs(progress) setDelegate:NO animate:NO];
			
			break;
			
			
		case UIGestureRecognizerStateFailed:
			[self setFlipProgress:0.0 setDelegate:YES animate:YES];
			currentPage = oldPage;
            
			break;
			
            
		case UIGestureRecognizerStateRecognized:
			if (hasFailed) {
				[self setFlipProgress:0.0 setDelegate:YES animate:YES];
				currentPage = oldPage;
				
				return;
			}
			
			if (fabs((translation + [recognizer velocityInView:self].x / 4) / self.bounds.size.width) > 0.5) {
				setNextViewOnCompletion = YES;
				[self setFlipProgress:1.0 setDelegate:YES animate:YES];
			} else {
				[self setFlipProgress:0.0 setDelegate:YES animate:YES];
				currentPage = oldPage;
			}

			break;
	}
}

/**
 When the user swipes right, go back a page.
 */
- (void) swippedRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        int change = landscapeShowsTwoPages && [self isLandscape] ? 2 : 1;
        [self setCurrentPage:MAX(self.currentPage - change, 0) animated:YES];
    }
}

/**
 When the user swipes left, go forward a page.
 */
- (void) swippedLeft:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        int change = landscapeShowsTwoPages && [self isLandscape] ? 2 : 1;
        [self setCurrentPage:MIN(self.currentPage + change, numberOfPages-1) animated:YES];
    }
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (animating) {
		return NO;
	}
    int x = [touch locationInView:self].x;
    int width = self.bounds.size.width - self.bounds.origin.x;
    int delta = [self getPagingMarginDelta: width];
    
    BOOL isInMargin = x < delta || x > width - delta;
    
    if (!isInMargin && gestureRecognizer == tapRecognizer) {
        if ([[self flipperDelegate] respondsToSelector:@selector(pageTapped:)]) {
            [[self flipperDelegate] pageTapped:currentPage];
        }
    }
    
    if (gestureRecognizer == tapRecognizer || gestureRecognizer == panRecognizer) {
        return isInMargin;
    } else {
        return !isInMargin;
    }
}

#pragma mark -
#pragma mark Frame management


- (void) setFrame:(CGRect) value {
	super.frame = value;

	numberOfPages = [dataSource numberOfPages];
    
    BOOL isLandscape = value.size.width > value.size.height;
    if (!(drawnInPortrait || drawnInLandscape) || (drawnInPortrait && isLandscape) || (drawnInLandscape && !isLandscape)) {
        [self refreshCurrentPage];
    }
    else {
        [self reportPageChange];
    }
    drawnInPortrait = !isLandscape;
    drawnInLandscape = isLandscape;
}


#pragma mark -
#pragma mark Initialization and memory management


+ (Class) layerClass {
	return [CATransformLayer class];
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
        swipeLeft = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swippedLeft:)] autorelease];
        swipeRight = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swippedRight:)] autorelease];
		panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)] autorelease];
        
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
		[tapRecognizer requireGestureRecognizerToFail:panRecognizer];
        
        tapRecognizer.delegate = panRecognizer.delegate = swipeRight.delegate = swipeLeft.delegate = self;
		
        [self addGestureRecognizer:tapRecognizer];
		[self addGestureRecognizer:panRecognizer];
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
        
        landscapeShowsTwoPages = YES;
    }
    return self;
}


- (void)dealloc {
	self.dataSource = Nil;
	self.currentView = Nil;
	self.nextView = Nil;
    [super dealloc];
}


@end
