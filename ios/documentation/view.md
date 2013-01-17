# Ti.PageFlip.View

## Description

Displays flippable pages to the user. The user can turn pages by sliding their finger across the screen, or by taping on the
far left or right to go back or advance, respectively.

## Properties

### pdf [string]

A URL to a PDF document. If this property is specified, the module will automatically determine the page counts and views. If you want more control over what is visible, utilize the "pageCount" and "loadPage" properties.

### transition [int]

Controls how the pages look when they flip. Defaults to _TRANSITION\_FLIP_ Use the TRANSITION_ constants in _[Ti.PageFlip][]_.

### transitionDuration [float]

The number of seconds a complete transition should take. Defaults to 0.5. Note that the CURL transition does NOT support this property.

### pagingMarginWidth [int]

The width of the area around the edge where the user can change pages. This includes both tap-to-advance and grabbing the edge of the page. Defaults to 10%. To disable this feature, set it to 0. Note that the CURL transition does NOT support this property.

### landscapeShowsTwoPages [bool]

Indicates if two pages should be shown when the device is in its landscape orientation. Note that this does not influence the page numbering or counts.

### enableBuiltInGestures [bool]

Controls whether or not the built in gestures are enabled (tap, pan, or swipe to change pages).

### pages [array]

Contains all of the views that you want the user to be able to flip through. Can be any combination of visible elements, such as Ti.UI.View or Ti.UI.Label, etc.

### currentPage [int, readonly]

The currently visible page. Use the "changeCurrentPage" method to move the user to another page. This uses a 0-based index.

### pageCount [int, readonly]

Returns the total number of pages.

## Methods

### changeCurrentPage(index, animate)

Moves the user to the specified page at the 0-based index, optionally animating them there.

* index [int] The index to the page.
* animate [bool, optional] Whether or not to animate the transition.

### insertPageBefore(index, page)

Inserts a page in to the view hierarchy before the specified 0-based index. The pages after this index will be renumbered to make room for the new page.

* index [int] The index _before_ which the page should be inserted.
* page [view] Any combination of visible elements, such as Ti.UI.View or Ti.UI.Label, etc.

### insertPageAfter(index, page)

Inserts a page in to the view hierarchy after the specified 0-based index. The pages after this index will be renumbered to make room for the new page.

* index [int] The index _before_ which the page should be inserted.
* page [view] Any combination of visible elements, such as Ti.UI.View or Ti.UI.Label, etc.

### appendPage(page)

Appends a page to the end of the pages.

* page [view] Any combination of visible elements, such as Ti.UI.View or Ti.UI.Label, etc.

### deletePage(index)

Removes the page at the specified 0-based index. The pages after the specified index will be renumbered to take up the space left by the removed page.

* index [int] The index _before_ which the page should be inserted.

## Events

### change

Fired when the user moves to another page or the device reorients. Handlers will receive one dictionary as their first argument. The following
properties will be available:

* currentPage [int]: The 0-based index of the visible page.
* pageCount [int]: The total number of pages.

### flipStarted

Fired when a user starts to move to another page.

### tap

Fired when the user taps inside of the pagingMarginWidth. This does not prevent other views inside the page flip from receiving touches.

* currentPage [int]: The 0-based index of the clicked page.

[Ti.PageFlip]: index.html