//
//  AFKPageFlipper.h
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TiUtils.h"
#import "Transition.h"


typedef enum PageflipTransition {
	PageflipTransitionFlip,
    PageflipTransitionFade,
	PageflipTransitionSlide,
	PageflipTransitionCurl
} PageflipTransitionType;


@class PageFlipper;


@protocol AFKPageFlipperDataSource

- (NSInteger)numberOfPages;
- (UIView*)viewForPage:(NSInteger)page withBounds:(CGRect)bounds;

@end


@protocol AFKPageFlipperDelegate
@optional
- (void)pageChanged:(NSInteger)currentPage withPageCount:(NSInteger)pageCount;
- (void)pageTapped:(NSInteger)currentPage;
- (void)transitionStarted;
@end


@interface PageFlipper : UIView<UIGestureRecognizerDelegate> {
	NSObject <AFKPageFlipperDataSource> *dataSource;
    NSObject <Transition> *transition;
	NSInteger currentPage;
	NSInteger numberOfPages;
	
	UIView *currentView;
	UIView *newView;
	
	BOOL setNextViewOnCompletion;
	BOOL animating;
	
	BOOL disabled;
    BOOL landscapeShowsTwoPages;
    
    BOOL drawnInLandscape;
    BOOL drawnInPortrait;
    
    float rootTransitionDuration;
    
    TiDimension pagingMarginWidth;
    
    NSObject<AFKPageFlipperDelegate>* flipperDelegate;
    
    UITapGestureRecognizer *tapRecognizer;
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
    UIPanGestureRecognizer *panRecognizer;
}

@property (nonatomic,retain) NSObject <AFKPageFlipperDataSource> *dataSource;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) float transitionDuration;

@property (nonatomic,assign) BOOL disabled;
@property (nonatomic,readwrite) BOOL landscapeShowsTwoPages;

@property (nonatomic,assign) TiDimension pagingMarginWidth;

@property (nonatomic,assign) NSObject<AFKPageFlipperDelegate>* flipperDelegate;
@property (nonatomic,assign) NSObject<Transition>* transition;

- (BOOL) isLandscape;
- (void) setCurrentPage:(NSInteger) value animated:(BOOL) animated;
- (void) refreshCurrentPage;

@end
