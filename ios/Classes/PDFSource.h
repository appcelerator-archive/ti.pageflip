/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Source.h"
#import "PDFRenderer.h"


@interface PDFSource : NSObject<Source> {
    CGPDFDocumentRef pdfDocument;
}

-(id)initWithURL:(NSURL*)url andProxy:(TiProxy*)value;

@end
