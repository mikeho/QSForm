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
#import "QSControls.h"

@implementation QSFormViewController : UITableViewController

@synthesize _objDelegate;
@synthesize _objNavigatedViewController;
@synthesize _strHeaderText;
@synthesize _objSelectedIndexPath;
@synthesize _blnMakeAllLabelsShortFlag;
@synthesize _blnSuspendScrollRestoreFlag;

- (QSFormViewController *)initAtTop:(NSInteger)intTop NavigatedViewController:(UIViewController *)objNavigatedViewController {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		[[self view] setFrame:CGRectMake(0, intTop, [UIScreen mainScreen].bounds.size.width, 5000)];
		[[self tableView] setScrollEnabled:false];
        
        // For iOS7+, the scrollviews, and by association -- tableviews, now have default content
        // insets.  We will get rid of these to let the table fit as it did in iOS6.
        NSString *reqSysVer = @"7";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
            
            CGFloat navigationHeight = self.navigationController.navigationBar.frame.size.height;
            
            // we are iOS7 or higher
            [self tableView].tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self tableView].bounds.size.width, 0.1f)];
            [self tableView].tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self tableView].bounds.size.width, navigationHeight + kLabelTopMargin)];
        }

		_objFormItemArray = [[NSMutableArray alloc] init];
		_blnMakeAllLabelsShortFlag = false;
		_blnAnimateUpdateFlag = false;

		_objNavigatedViewController = objNavigatedViewController;
		[[_objNavigatedViewController view] addSubview:[self view]];

		UIView * objBackgroundView = [[UIView alloc] init];
		[objBackgroundView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
		[[self tableView] setBackgroundView:objBackgroundView];
		[objBackgroundView release];
	}
	return self;
}

- (QSFormItem *)addFormItem:(QSFormItem *)objItem {
	[objItem setIndex:([_objFormItemArray count] + 1000)];
	[objItem setForm:self];
	[_objFormItemArray addObject:objItem];

	if (_blnMakeAllLabelsShortFlag)
		[objItem setShortLabelFlag:true];

	return objItem;
}

- (void)beginAnimatedUpdates {
	NSAssert(_blnAnimateUpdateFlag == false, @"Cannot call beginAnimatedUpdates() when already in an animation state");
	_blnAnimateUpdateFlag = true;
	_blnNoMoreDeletesFlag = false;

	_objAdditionIndexPaths = [[NSMutableArray alloc] init];
	_objDeleteIndexPaths = [[NSMutableArray alloc] init];
}

- (void)endAnimatedUpdatesWithAddItemAnimation:(UITableViewRowAnimation)intAddItemAnimation withRemoveItemAnimation:(UITableViewRowAnimation)intRemoveItemAnimation  {
	NSAssert(_blnAnimateUpdateFlag == true, @"Cannot call endAnimatedUpdates() when beginAnimatedUpdates() was never called");
	_blnAnimateUpdateFlag = false;

	if (([_objAdditionIndexPaths count] == 0) && ([_objDeleteIndexPaths count] == 0)) {
		[_objAdditionIndexPaths release];
		[_objDeleteIndexPaths release];
		_objAdditionIndexPaths = nil;
		_objDeleteIndexPaths = nil;
	}
	

	// BEGIN Animation Block
	[[self tableView] beginUpdates];
	
	// First perform Deletes (if applicable)
	if ([_objDeleteIndexPaths count]) {
		[[self tableView] deleteRowsAtIndexPaths:_objDeleteIndexPaths withRowAnimation:intRemoveItemAnimation];
	}
	
	// Next perform Additions (if applicable)
	if ([_objAdditionIndexPaths count]) {
		[[self tableView] insertRowsAtIndexPaths:_objAdditionIndexPaths withRowAnimation:intAddItemAnimation];
	}

	// Commit Animation Block
	[[self tableView] endUpdates];
	
	// Cleanup
	[_objAdditionIndexPaths release];
	[_objDeleteIndexPaths release];
	_objAdditionIndexPaths = nil;
	_objDeleteIndexPaths = nil;
}

- (QSFormItem *)addFormItem:(QSFormItem *)objItem afterFormItemKey:(NSString *)strKey {
	NSAssert(_blnAnimateUpdateFlag == true, @"Cannot addFormItem with animation when beginAnimatedUpdates() was never called");
	_blnNoMoreDeletesFlag = true;

	// First, figure out the Position Index #
	int intIndexPosition = -1;
	for (int intIndex = 0; intIndex < [_objFormItemArray count]; intIndex++) {
		if ([[[_objFormItemArray objectAtIndex:intIndex] key] isEqualToString:strKey]) {
			intIndexPosition = intIndex + 1;
		}
	}
	
	NSAssert1(intIndexPosition >= 0, @"Cannot find form item with key: %@", strKey);

	// Setup the Item itself
	[objItem setIndex:([_objFormItemArray count] + 1000)];
	[objItem setForm:self];
	[_objFormItemArray insertObject:objItem atIndex:intIndexPosition];

	if (_blnMakeAllLabelsShortFlag) [objItem setShortLabelFlag:true];
	
	// Add the indexpath
	[_objAdditionIndexPaths addObject:[NSIndexPath indexPathForRow:intIndexPosition inSection:0]];
	return objItem;
}

- (void)removeFormItem:(QSFormItem *)objItem {
	NSAssert(_blnAnimateUpdateFlag == true, @"Cannot addFormItem with animation when beginAnimatedUpdates() was never called");
	NSAssert(_blnNoMoreDeletesFlag == false, @"Cannot removeFormItem() once addFormItem() is called within an animation block");
	
	// Figure out the IndexPosition
	int intIndexPosition = -1;
	for (int intIndex = 0; intIndex < [_objFormItemArray count]; intIndex++) {
		if ([_objFormItemArray objectAtIndex:intIndex] == objItem) {
			intIndexPosition = intIndex;
		}
	}

	NSAssert1(intIndexPosition >= 0, @"Cannot find form item with key: %@", [objItem key]);
	
	// Remove the Item Itself
	[_objFormItemArray removeObjectAtIndex:intIndexPosition];
	
	// Add the IndexPath to the Removal List
	[_objDeleteIndexPaths addObject:[NSIndexPath indexPathForRow:intIndexPosition inSection:0]];
}

- (QSFormItem *)getFormItemWithKey:(NSString *)strKey {
	for (QSFormItem * objItem in _objFormItemArray) {
		if ([[objItem key] isEqualToString:strKey])
			return objItem;
	}
	return nil;
}

- (QSFormItem *)getFormItemAtIndex:(NSInteger)intIndex {
	return [_objFormItemArray objectAtIndex:intIndex];
}

- (NSArray *)getFormItems {
	return [NSArray arrayWithArray:_objFormItemArray];
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
	
	if ((_objDelegate != nil) && [_objDelegate respondsToSelector:@selector(formWillRedraw:)]) {
		[_objDelegate formWillRedraw:self];
	}
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
	[self setSelectedIndexPath:nil];
	[self setHeaderText:nil];
	[self setNavigatedViewController:nil];

	// Unreference self from all FormItems
	for (QSFormItem * objFormItem in _objFormItemArray) {
		[objFormItem setForm:nil];
	}
	
	[_objAdditionIndexPaths release];
	[_objDeleteIndexPaths release];

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
	[(QSFormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] setIndexPath:indexPath];
	return [(QSFormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] getUITableViewCellForUITableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [(QSFormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] getHeight];
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

		[(QSFormItem *)[_objFormItemArray objectAtIndex:[_objSelectedIndexPath row]] tableViewCellUnselect:[tableView cellForRowAtIndexPath:_objSelectedIndexPath]];
		[self setSelectedIndexPath:nil];
	} else {
		_blnSuspendScrollRestoreFlag = false;
	}

	// Alert the FormItem that it has been tapped -- find out whether or not it is telling us to "Select" it
	if ([(QSFormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] enabledFlag]) {
		// First, pass to the deleagte
		if ((_objDelegate != nil) && ([_objDelegate respondsToSelector:@selector(form:didSelectFormItem:)])) {
			[_objDelegate form:self didSelectFormItem:[_objFormItemArray objectAtIndex:[indexPath row]]];
		}

		bool blnSelectFlag = [(QSFormItem *)[_objFormItemArray objectAtIndex:[indexPath row]] tableViewCellTapped:[tableView cellForRowAtIndexPath:indexPath]];

		if (blnSelectFlag) {
			[self setSelectedIndexPath:indexPath];
		}
	}

	return nil;
}

- (void)unselectTableCells {
	// If there is an already-selected row, let's tell the FormItem at that row to "unselect"
	if (_objSelectedIndexPath) {
		[(QSFormItem *)[_objFormItemArray objectAtIndex:[_objSelectedIndexPath row]] tableViewCellUnselect:[[self tableView] cellForRowAtIndexPath:_objSelectedIndexPath]];
		[self setSelectedIndexPath:nil];
	}
}

- (CGFloat)getHeight {
	CGFloat fltHeight = 1;
	for (QSFormItem * objFormItem in _objFormItemArray)
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
