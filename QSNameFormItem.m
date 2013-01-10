/**
 * QSListFormItem.m
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

#import <UIKit/UITableView.h>
#import "QSForm.h"
#import "QSControls.h"
#import "QSUtilities.h"

@implementation QSNameFormItem

@synthesize _intIdValue;
@synthesize _objTableHeaderView;

#pragma mark -
#pragma mark Initializers

- (QSNameFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel IdValue:(int)intIdValue {
	if (self = (QSNameFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_intIdValue = intIdValue;
		_strNameValue = nil;

		_arrNameArrayByLetter = [[NSMutableArray alloc] initWithCapacity:26];
		_arrIdArrayByLetter = [[NSMutableArray alloc] initWithCapacity:26];
		for (int intIndex = 0; intIndex < 26; intIndex++) {
			[_arrNameArrayByLetter addObject:[[[NSMutableArray alloc] init] autorelease]];
			[_arrIdArrayByLetter addObject:[[[NSMutableArray alloc] init] autorelease]];
		}
	}
	return self;
}


#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[_strNameValue release];
	[_lblField release];
	[_objTableViewController release];
	[_arrNameArrayByLetter release];
	[_arrIdArrayByLetter release];
	[_objTableViewController release];
	[_objTableHeaderView release];
	[super dealloc];
}


#pragma mark -
#pragma mark FormItem Default Overrides

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];
	
	[self refreshImageView];
	if ([[objCell subviews] indexOfObject:_lblField] == NSNotFound) {
		[[objCell contentView] addSubview:_lblField];
	}

	[objCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	return objCell;
}

- (CGFloat)refreshImageView {
	// Setup Label
	if (_lblField == nil) {
		// _lblField to retain
		_lblField = [[UILabel alloc] initWithFrame:[self getControlFrameWithHeight:500]];
		_lblField.tag = _intIndex;
		[_lblField setLineBreakMode:UILineBreakModeWordWrap];
		[_lblField setNumberOfLines:0];
	}

	// Do we have a valid value?
	if (_intIdValue && (_strNameValue != nil)) {
		[_lblField setText:_strNameValue];
		[_lblField setTextColor:[UIColor blackColor]];
		[_lblField setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
	} else {
		[_lblField setText:@"Tap to Add"];
		[_lblField setTextColor:[UIColor grayColor]];
		[_lblField setFont:[UIFont italicSystemFontOfSize:[UIFont systemFontSize]]];
	}

	// Setup the Height
	CGRect objFrame = [_lblField frame];
	objFrame.size.height = 1000;
	[_lblField setFrame:objFrame];
	[QSLabels trimFrameHeightForLabel:_lblField WithMinHeight:25];
	return fmax([super getHeight], kLabelTopMargin + _lblField.bounds.size.height + kLabelBottomMargin);
}

- (CGFloat)getHeight {
	return [self refreshImageView];
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {
	_objTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	[[_objTableViewController navigationItem] setTitle:_strLabel];
	[[_objTableViewController navigationItem] setPrompt:[[[_objForm navigatedViewController] navigationItem] prompt]];
	[[_objTableViewController tableView] setDelegate:self];
	[[_objTableViewController tableView] setDataSource:self];

	// Add the Optional Bar (if applicable)
	if (_objTableHeaderView != nil) {
		[[_objTableViewController tableView] setTableHeaderView:_objTableHeaderView];
	}

	// Define Back Button Stuff
	UIBarButtonItem * btnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back"
																 style:UIBarButtonItemStyleBordered
																target:self
																action:@selector(backClick:)];
	[[_objTableViewController navigationItem] setLeftBarButtonItem:btnBack];
	[btnBack release];

	if (_strSubscreenPrompt != nil) {
		[[_objTableViewController navigationItem] setPrompt:_strSubscreenPrompt];
	}
		
	[[[_objForm navigatedViewController] navigationController] pushViewController:_objTableViewController
																		 animated:true];

	// Pre-select the Option/Value
	int intSectionIndex = 0;
	
	for (int intLetterIndex = 0; intLetterIndex < 26; intLetterIndex++) {
		if ([[_arrIdArrayByLetter objectAtIndex:intLetterIndex] count] > 0) {
			NSArray * intIdNumberArray = [_arrIdArrayByLetter objectAtIndex:intLetterIndex];
			for (int intRowIndex = 0; intRowIndex < [intIdNumberArray count]; intRowIndex++) {
				if ([[intIdNumberArray objectAtIndex:intRowIndex] intValue] == _intIdValue) {
					[[_objTableViewController tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:intRowIndex inSection:intSectionIndex] animated:false scrollPosition:UITableViewScrollPositionMiddle];
				}
			}
			intSectionIndex++;
		}
	}

	return false;
}

#pragma mark -
#pragma mark Name/Value Pair List Management
- (void)addItemWithFirstName:(NSString *)strFirstName lastName:(NSString *)strLastName idValue:(int)idValue {
	// Figure out the First Letter's ORD Value
	int intOrd = [[[strLastName uppercaseString] substringToIndex:1] cStringUsingEncoding:NSUTF8StringEncoding][0];
	intOrd -= 'A';
	NSAssert1(((intOrd >= 0) && (intOrd < 26)), @"Invalid Last Name: %@", strLastName);
	
	// Add the name and ID to the local arrays
	[[_arrNameArrayByLetter objectAtIndex:intOrd] addObject:[NSString stringWithFormat:@"%@ %@", strFirstName, strLastName]];
	[[_arrIdArrayByLetter objectAtIndex:intOrd] addObject:[NSNumber numberWithInt:idValue]];
	
	// Update our name value if it is what is selected
	if (idValue == _intIdValue) {
		if (_strNameValue != nil) {
			[_strNameValue release];
		}
		_strNameValue = [[NSString stringWithFormat:@"%@ %@", strFirstName, strLastName] retain];
	}
}

- (void)removeAllNames {
	[_arrNameArrayByLetter release];
	[_arrIdArrayByLetter release];
	[_strNameValue release];

	_strNameValue = nil;

	_arrNameArrayByLetter = [[NSMutableArray alloc] initWithCapacity:26];
	_arrIdArrayByLetter = [[NSMutableArray alloc] initWithCapacity:26];
	for (int intIndex = 0; intIndex < 26; intIndex++) {
		[_arrNameArrayByLetter addObject:[[[NSMutableArray alloc] init] autorelease]];
		[_arrIdArrayByLetter addObject:[[[NSMutableArray alloc] init] autorelease]];
	}
	
}

- (void)refreshTableView {
	if (_objTableViewController != nil) [(UITableView *)[_objTableViewController view] reloadData];
}


#pragma mark -
#pragma mark List Selector TableViewController Management

- (IBAction)backClick:(id)sender {
	[[_objTableViewController navigationController] popViewControllerAnimated:true];
	[_objTableViewController release];
	_objTableViewController = nil;
	[_objForm redraw];
	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int intCount = 0;
	for (int intIndex = 0; intIndex < 26; intIndex++)
		if ([[_arrNameArrayByLetter objectAtIndex:intIndex] count] > 0) intCount++;

    return intCount;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel * lblTest = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25.0f)];
	
	[lblTest setText:[NSString stringWithFormat:@"   %@", [[self sectionIndexTitlesForTableView:tableView] objectAtIndex:section]]];
	[lblTest setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
	[lblTest setTextColor:[UIColor whiteColor]];
	[lblTest setBackgroundColor:[UIColor darkGrayColor]];
	[lblTest autorelease];
	return lblTest;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 25.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int intCurrentSectionNumber = 0;
	for (int intIndex = 0; intIndex < 26; intIndex++) {
		if ([[_arrNameArrayByLetter objectAtIndex:intIndex] count] > 0) {
			if (section == intCurrentSectionNumber) {
				return [[_arrNameArrayByLetter objectAtIndex:intIndex] count];
			}
			intCurrentSectionNumber++;
		}
	}

	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return index;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	NSMutableArray * strLetterArray = [[NSMutableArray alloc] init];
	for (int intIndex = 0; intIndex < 26; intIndex++) {
		if ([[_arrNameArrayByLetter objectAtIndex:intIndex] count] > 0) {
			[strLetterArray addObject:[NSString stringWithFormat:@"%c", (intIndex + 'A')]];
		}
	}
	
	NSArray * arrToReturn = [NSArray arrayWithArray:strLetterArray];
	[strLetterArray release];
	return arrToReturn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * strIdentifier = @"listFormItemCellIdentifier";
	UITableViewCell * objCell = [[_objTableViewController tableView] dequeueReusableCellWithIdentifier:strIdentifier];

    if (objCell == nil) {
        objCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier] autorelease];
	}

	[[objCell textLabel] setTextColor:[UIColor blackColor]];
	[[objCell textLabel] setBackgroundColor:[UIColor clearColor]];

	// Get Name  and IdNumber Array
	NSArray * strNameArray;
	NSArray * intIdNumberArray;
	int intCurrentSectionNumber = 0;
	for (int intIndex = 0; intIndex < 26; intIndex++) {
		if ([[_arrNameArrayByLetter objectAtIndex:intIndex] count] > 0) {
			if ([indexPath section] == intCurrentSectionNumber) {
				strNameArray = [_arrNameArrayByLetter objectAtIndex:intIndex];
				intIdNumberArray = [_arrIdArrayByLetter objectAtIndex:intIndex];
			}
			intCurrentSectionNumber++;
		}
	}

	
	[[objCell textLabel] setText:[strNameArray objectAtIndex:[indexPath row]]];
    return objCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_blnChangedFlag = true;

	int intSectionIndex = 0;
	NSArray * strNameArray;
	NSArray * intIdNumberArray;
	for (int intIndex = 0; intIndex < 26; intIndex++) {
		if ([[_arrNameArrayByLetter objectAtIndex:intIndex] count] > 0) {
			if (intSectionIndex == [indexPath section]) {
				strNameArray = [_arrNameArrayByLetter objectAtIndex:intIndex];
				intIdNumberArray = [_arrIdArrayByLetter objectAtIndex:intIndex];
			}
			intSectionIndex++;
		}
	}
	
	[_strNameValue release];
	_strNameValue = [[strNameArray objectAtIndex:[indexPath row]] retain];
	_intIdValue = [[intIdNumberArray objectAtIndex:[indexPath row]] intValue];

	return indexPath;
}


@end