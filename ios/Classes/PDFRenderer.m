//
//  PDFRendererView.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import "PDFRenderer.h"

@interface PDFRenderer(Private)
- (void) drawPDFPage:(CGPDFPageRef) pdfPage inRect:(CGRect) rect usingContext:(CGContextRef) context;
@end

@implementation PDFRenderer


#pragma mark -
#pragma mark Initialization and memory management


- (id) initWithFrame:(CGRect) frame {
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	return self;
}


- (void)dealloc {
    if (pdfDocument) {
        CGPDFDocumentRelease(pdfDocument);
    }
    [super dealloc];
}


#pragma mark -
#pragma mark Property management

@synthesize pdfDocument;
- (void) setPdfDocument:(CGPDFDocumentRef) value {
	if (pdfDocument) {
		CGPDFDocumentRelease(pdfDocument);
	}
	pdfDocument = CGPDFDocumentRetain(value);
}


@synthesize pageNumber;
- (void) setPageNumber:(int) value {
	pageNumber = value;
}

#pragma mark -
#pragma mark Drawing


- (void) setFrame:(CGRect) value {
	[super setFrame:value];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Clear background
	CGContextClearRect(context, self.bounds);
	CGContextSaveGState(context);
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextFillRect(context, self.bounds);
	CGContextRestoreGState(context);
	
	// Load PDF page
    [self drawPDFPage:CGPDFDocumentGetPage(pdfDocument, pageNumber+1) inRect:self.bounds usingContext:context];
}

- (void) drawPDFPage:(CGPDFPageRef) pdfPage inRect:(CGRect) rect usingContext:(CGContextRef) context {
	CGContextSaveGState(context);
	
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGRect boundingBox = CGPDFPageGetBoxRect(pdfPage, kCGPDFCropBox);
	
	float ratio = MIN(rect.size.width / boundingBox.size.width, rect.size.height / boundingBox.size.height);
	
	CGAffineTransform pdfTransform = CGAffineTransformMakeTranslation(rect.origin.x + (rect.size.width - boundingBox.size.width * ratio) / 2, rect.origin.y + (rect.size.height - boundingBox.size.height * ratio) / 2);
	pdfTransform = CGAffineTransformScale(pdfTransform, ratio, ratio);
	
	CGContextConcatCTM(context, pdfTransform);
	CGContextDrawPDFPage(context, pdfPage);
	CGContextRestoreGState(context);
}

@end
