/**
 * QSFormViewController.m
 * 
 * Copyright (c) 2010 - 2011, Quasidea Development, LLC
 * For more information, please go to http://www.quasidea.com/
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "QSForm.h"

@implementation FormViewController : UITableViewController

@synthesize _objNavigatedViewController;
@synthesize _strHeaderText;
@synthesize _objSelectedIndexPath;
@synthesize _blnSetAllLabelsShortFlag;

- (FormViewController *)initAtTop:(NSInteger)intTop NavigatedViewController:(UIViewController *)objNavigatedViewController {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		[[self view] setFrame:CGRectMake(0, intTop, [UIScreen mainScreen].bounds.size.width, 5000)];
		[[self tableView] setScrollEnabled:false];

		_objFormItemArray = [[NSMutableArray alloc] init];
		_blnSetAllLabelsShortFlag = false;

		_objNavigatedViewController = objNavigatedViewController;
		[_objNavigatedViewController retain];
		[[_objNavigatedViewController view] addSubview:[self view]];
		[[self view] setBackgroundColor:[UIColor clearColor]];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	}
	return self;
}

- (void)resetScrolling {
	UIScrollView * objScrollView = (UIScrollView *)[_objNavigatedViewController view];
	[objScrollView setScrollEnabled:_blnCurrentScrollEnableFlag];
	[objScrollView setContentSize:_objCurrentContentSize];
}

- (void)keyboardWillHide:(id)sender {
	if (_blnSuspendScrollRestoreFlag) return;

	UIScrollView * objScrollView = (UIScrollView *)[_objNavigatedViewController view];
	[objScrollView setFrame:_objCurrentFrame];
	[objScrollView setContentOffset:_objCurrentContentOffset animated:true];
	[self performSelector:@selector(resetScrolling) withObject:nil afterDelay:0.4];
}

- (void)keyboardWillShow:(id)sender {
	if (_blnSuspendScrollRestoreFlag) {
		_blnSuspendScrollRestoreFlag = false;
		return;
	}

	CGFloat fltYPosition = [self getYPositionForCellAtIndexPath:_objSelectedIndexPath];
	fltYPosition -= kTopMargin;

	UIScrollView * objScrollView = (UIScrollView *)[_objNavigatedViewController view];
	_objCurrentFrame = [objScrollView frame];
	_objCurrentContentSize = [objScrollView contentSize];
	_objCurrentContentOffset = [objScrollView contentOffset];
	_blnCurrentScrollEnableFlag = [objScrollView isScrollEnabled];
	
	CGFloat fltHeight;
	if ([[_objNavigatedViewController navigationItem] prompt] == nil) {
		fltHeight = 200;
	} else {
		fltHeight = 170;
	}

	[UIView beginAnimations:@"" context:NULL];
	[objScrollView setFrame:CGRectMake(_objCurrentFrame.origin.x, _objCurrentFrame.origin.y, [UIScreen mainScreen].bounds.size.width, fltHeight)];
	[UIView commitAnimations];

	[objScrollView setScrollEnabled:true];
	[objScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000)];

	CGRect objRectToScrollTo = CGRectMake(0, fltYPosition, [UIScreen mainScreen].bounds.size.width, [[self getFormItemAtIndex:[_objSelectedIndexPath row]] getHeight] + kTopMargin*2);
	[objScrollView scrollRectToVisible:objRectToScrollTo
							  animated:true];
}

- (FormItem *)addFormItem:(FormItem *)objItem {
	[objItem Index:([_objFormItemArray count] + 1000)];
	[objItem Form:self];
	[_objFormItemArray addObject:objItem];

	if (_blnSetAllLabelsShortFlag)
		[objItem ShortLabelFlag:true];

	return objItem;
}

- (FormItem *)getFormItemWithKey:(NSString *)strKey {
	for (FormItem * objItem in _objFormItemArray) {
		if ([[objItem Key] isEqualToString:strKey])
			return objItem;
	}
	return nil;
}

- (FormItem *)getFormItemAtIndex:(NSInteger)intIndex {
	return [_objFormItemArray objectAtIndex:intIndex];
}

- (CGFloat)adjustHeightToFit {
	CGRect objFrame = self.tableView.frame;
	objFrame.size.height = [_objFormItemArray count] * 20;

	[[self tableView] setFrame:objFrame];
	return objFrame.size.height;
}

- (void)removeAllFormItems {
	[_objFormItemArray removeAllObjects];
}

- (void)redraw {
	[[self tableView] reloadData];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self SelectedIndexPath:nil];
	[self HeaderText:nil];
	[self NavigatedViewController:nil];
	[_objFormItemArray release];
    [super dealloc];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return @"Hello, World!";
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (_strHeaderText == nil)
		return 0;
	else
		return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	// Only if "HeaderText" is defined
	if (_strHeaderText == nil) return nil;

	// Because the returned View's frame is set by UITableViewController, we cannot
	// do things like indent, etc.  So the returned  view will be a wrapper for us.
	UIView * vweHeader = [[UIView alloc] initWithFrame:CGRectZero];

	// The actual header view is a Label
	UILabel * lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
	[lblHeader setBackgroundColor:[UIColor clearColor]];
	[lblHeader setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:1.0]];
	[lblHeader setFont:[UIFont boldSystemFontOfSize:16]];

	[lblHeader setText:_strHeaderText];

	// Put the actual header view into the wrapper and return the wrapper
	[vweHeader addSubview:lblHeader];
	[lblHeader release];
	[vweHeader autorelease];
	return vweHeader;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_objFormItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	[(FormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] IndexPath:indexPath];
	return [(FormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] getUITableViewCellForUITableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [(FormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] getHeight];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// If we're tapping the exact row that is already currently selected, then do nothing
	if (_objSelectedIndexPath == indexPath) {
		return nil;
	}
	
	// If there is an already-selected row, let's tell the FormItem at that row to "unselect"
	if (_objSelectedIndexPath) {
		// IF the currently selected and next selected are both TextFieldFormItems, we gotta suspend keyboard rescroll stuff
		if (([[_objFormItemArray objectAtIndex:[_objSelectedIndexPath row]] isMemberOfClass:NSClassFromString(@"TextFieldFormItem")]) &&
			([[_objFormItemArray objectAtIndex:[indexPath row]] isMemberOfClass:NSClassFromString(@"TextFieldFormItem")])) {
			_blnSuspendScrollRestoreFlag = true;
		} else {
			_blnSuspendScrollRestoreFlag = false;
		}

		[(FormItem *)[_objFormItemArray objectAtIndex:[_objSelectedIndexPath row]] tableViewCellUnselect:[tableView cellForRowAtIndexPath:_objSelectedIndexPath]];
		[self SelectedIndexPath:nil];
	} else {
		_blnSuspendScrollRestoreFlag = false;
	}

	// Alert the FormItem that it has been tapped -- find out whether or not it is telling us to "Select" it
	bool blnSelectFlag = [(FormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] tableViewCellTapped:[tableView cellForRowAtIndexPath:indexPath]];

	if (blnSelectFlag) {
		[self SelectedIndexPath:indexPath];
	}

	return nil;
}

- (void)unselectTableCells {
	// If there is an already-selected row, let's tell the FormItem at that row to "unselect"
	if (_objSelectedIndexPath) {
		[(FormItem *)[_objFormItemArray objectAtIndex:[_objSelectedIndexPath row]] tableViewCellUnselect:[[self tableView] cellForRowAtIndexPath:_objSelectedIndexPath]];
		[self SelectedIndexPath:nil];
	}
}

- (CGFloat)getHeight {
	CGFloat fltHeight = 1;
	for (FormItem * objFormItem in _objFormItemArray)
		fltHeight += [objFormItem getHeight] + 1;
	return fltHeight;
}

- (CGFloat)getYPositionForCellAtIndexPath:(NSIndexPath *)objIndexPath {
	CGFloat fltYPosition = [self view].frame.origin.y;
	if (_strHeaderText != nil)
		fltYPosition += [self tableView:[self tableView] heightForHeaderInSection:[objIndexPath section]];
	else
		fltYPosition += kTopMargin;
	
	for (NSInteger intIndex = 0; intIndex < [objIndexPath row]; intIndex++) {
		fltYPosition += [[self getFormItemAtIndex:intIndex] getHeight];
	}

	return fltYPosition;
}

@end
