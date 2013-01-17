# Change Log
<pre>
v1.8.3  MOD-1118: Building with 2.1.3.GA and open sourcing
	
v1.8.2  MOD-688: Fixed issue with 1st page not displaying when pageflip controller is a child of another controller

v1.8.1	MOD-645: Added support for Titanium Mobile 2.0.1.
		MOD-615: Fixed blank page issue when rapidly flipping through.

v1.8	MOD-451: Added support for animating changeCurrentPage with the CURL transition.
		Fixed bounds checking when deleting and inserting pages.
		Updated example for proper bounds checking when callign changeCurrentPage to avoid superfluous animations.
		The CURL transition will now properly move to the previous page when the current page is deleted, or to a blank page if none are left.

v1.7	MOD-408: Fixed bounds checking on gestures and improved initialization performance.
		MOD-376: Fixed issue preventing page count from updating when adding or remove pages.
		Fixed issue where reorientation would sometimes result in the portrait view hiding behind the landscape view.
		Fixed crash when deleting the current page when there were not pages after it.

v1.6	MOD-367: Refresh the current page after setting a new view source (pages or pdf).

v1.5	MOD-354: Better cleanup when removing the view without closing the parent window.

v1.4	MOD-147: Added support for CURL transitions with iOS 5. Check out the example and documentation to find out more.
		BREAKING CHANGE: All page references are now 0 index based.
		BREAKING CHANGE: The first page with landscapeShowsTwoPages in landscape now shows on the LEFT, instead of on the RIGHT with an empty page on the left.
		BREAKING CHANGE: The total page count and current page are no longer influenced by being in landscape with landscapeShowsTwoPages.
		When rendering PDF pages, decreased the redraw time and memory footprint.
		MOD-330: Fixed convertPointToView with child views.

v1.3	MOD-251: Added a new property, "transitionDuration", that lets you control how long a complete transition will take (in seconds, defaults to 0.5). See the documentation and example for more information.
		MOD-274: Better cleanup of pages when the Page Flip View is collected.

v1.2	MOD-207: Added a "tap" event to the view to detect when the user touches within the margins.
		MOD-219: Fixed bug that positioned the first page while ignoring landscapeShowsTwoPages.
		Removed hard coded fade animation when setting pages.
		Memory improvements.

v1.1	MOD-189: Fixed edge case on setting landscapeShowsTwoPages when on the first page.
		MOD-188: Better memory management of transitions in the flipper and of views in the slide transition.
			Reorientation no longer causes a new animation to take place, it just jumps straight to the new view
			(which was causing a crash when the user reoriented and transitioned).

v1.0    Initial Release
