/**
 * Ti.Pageflip Module
 * Copyright (c) 2011-2013 by Appcelerator, Inc. All Rights Reserved.
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
