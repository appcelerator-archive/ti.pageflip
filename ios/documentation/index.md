# Ti.PageFlip Module

## Description

Display pages of data to your users. Comes stock with easy to turn pages, multiple transition effects (fade, flip, and slide), a quick PDF mode, and a view-based mode.

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the Ti.PageFlip Module

To access this module from JavaScript, you would do the following:

	var PageFlip = require('ti.pageflip');

## Methods

### Ti.PageFlip.createView({...})

Creates a [Ti.PageFlip.View][].

#### Arguments

Takes one argument, a dictionary with any of the properties from [Ti.PageFlip.View][].

## Properties

### Ti.PageFlip.TRANSITION\_FLIP [readonly, int]

When transitioning between pages, the page will "flip" from their spine.

### Ti.PageFlip.TRANSITION\_SLIDE [readonly, int]

When transitioning between pages, the page will slide on and off the screen.

### Ti.PageFlip.TRANSITION\_FADE [readonly, int]

When transitioning between pages, the pages will fade between each other.

### Ti.PageFlip.TRANSITION\_CURL [readonly, int, iOS 5 only]

When transitioning between pages, the pages will curl between each other from their spine.

## Usage

See example.

## Author

Dawson Toth

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=iOS%20PageFlip%20Module).

## License

Copyright(c) 2011-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.

[Ti.PageFlip.View]: view.html