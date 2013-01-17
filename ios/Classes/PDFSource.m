/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "PDFSource.h"


@implementation PDFSource


#pragma mark Initialization and Memory Management

-(id)initWithURL:(NSURL*)url andProxy:(TiProxy*)value
{
    if ((self = [super init])) {
        pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef) url);
    }
    return self;
}

- (void)dealloc {
    CGPDFDocumentRelease(pdfDocument);
    pdfDocument = nil;
    [super dealloc];
}


#pragma mark Data Source

- (NSInteger)numberOfPages
{
    return CGPDFDocumentGetNumberOfPages(pdfDocument);
}

- (UIView*)viewForPage:(NSInteger)page withBounds:(CGRect)bounds
{
    PDFRenderer *result = [[[PDFRenderer alloc] initWithFrame:bounds] autorelease];
    result.pdfDocument = pdfDocument;
    result.pageNumber = page;
    return result;
}


# pragma mark Page Management

-(void)insertPageAfter:(id)args
{
    NSLog(@"[ERROR] Attempted to call insertPageAfter when using a PDF in the PageFlip module; you can only use this method with the Views based approach!");
}

-(void)insertPageBefore:(id)args
{
    NSLog(@"[ERROR] Attempted to call insertPageAfter when using a PDF in the PageFlip module; you can only use this method with the Views based approach!");
}

-(void)appendPage:(id)args
{
	NSLog(@"[ERROR] Attempted to call insertPageAfter when using a PDF in the PageFlip module; you can only use this method with the Views based approach!");
}

-(void)deletePage:(id)args
{
    NSLog(@"[ERROR] Attempted to call insertPageAfter when using a PDF in the PageFlip module; you can only use this method with the Views based approach!");
}


@end
