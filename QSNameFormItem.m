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

@synthesize  _intIdValue;

#pragma mark -
#pragma mark Initializers

- (QSNameFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel IdValue:(int)intIdValue {
	if (self = (QSNameFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_intIdValue = intIdValue;
		_dctFirstName = [[NSMutableDictionary alloc] init];
		_dctLastName = [[NSMutableDictionary alloc] init];

		
		_arrNameArrayByLetter = [[NSMutableArray alloc] initWithCapacity:26];
		for (int intIndex = 0; intIndex < 26; intIndex++) {
			[_arrNameArrayByLetter addObject:[[[NSMutableArray alloc] init] autorelease]];
		}
	}
	return self;
}


#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[_dctLastName release];
	[_dctFirstName release];
	[_lblField release];
	[_objTableViewController release];
	[_arrNameArrayByLetter release];
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
	if (_intIdValue &&
		(([_dctLastName objectForKey:[NSNumber numberWithInt:_intIdValue]] != nil) ||
		 ([_dctFirstName objectForKey:[NSNumber numberWithInt:_intIdValue]] != nil))) {
		[_lblField setText:[NSString stringWithFormat:@"%@ %@",
							[_dctFirstName objectForKey:[NSNumber numberWithInt:_intIdValue]],
							[_dctLastName objectForKey:[NSNumber numberWithInt:_intIdValue]]]];
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

	return false;
}

#pragma mark -
#pragma mark Name/Value Pair List Management
- (void)addItemWithFirstName:(NSString *)strFirstName lastName:(NSString *)strLastName idValue:(int)idValue {
	[_dctFirstName setObject:[NSString stringWithFormat:@"%@ %@", strFirstName, strLastName]
					  forKey:[NSNumber numberWithInt:idValue]];
	
	// Update the Index Count
	
	int intOrd = [[[strLastName uppercaseString] substringToIndex:1] cStringUsingEncoding:NSUTF8StringEncoding][0];
	intOrd -= 'A';
	NSAssert1(((intOrd >= 0) && (intOrd < 26)), @"Invalid Last Name: %@", strLastName);
	
	[[_arrNameArrayByLetter objectAtIndex:intOrd] addObject:[NSString stringWithFormat:@"%@ %@", strFirstName, strLastName]];
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
		objCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:strIdentifier] autorelease];
	}
	
	[[objCell textLabel] setTextColor:[UIColor blackColor]];
	[[objCell textLabel] setBackgroundColor:[UIColor clearColor]];

	// Get Name Array
	NSArray * strNameArray;
	int intCurrentSectionNumber = 0;
	for (int intIndex = 0; intIndex < 26; intIndex++) {
		if ([[_arrNameArrayByLetter objectAtIndex:intIndex] count] > 0) {
			if ([indexPath section] == intCurrentSectionNumber) {
				strNameArray = [_arrNameArrayByLetter objectAtIndex:intIndex];
			}
			intCurrentSectionNumber++;
		}
	}

	
	[[objCell textLabel] setText:[strNameArray objectAtIndex:[indexPath row]]];

//			if ([_strSingleValue isEqualToString:[_strValueArray objectAtIndex:[indexPath row]]]) {
//				[tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
//			} else {
//				[tableView deselectRowAtIndexPath:indexPath animated:false];
//			}

    return objCell;
}

/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_blnChangedFlag = true;

	if (_blnAllowOtherFlag && ([indexPath row] == [_strNameArray count])) {
		_objAlertView = [[UIAlertView alloc] initWithTitle:@"Other..." message:@" " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		UITextField * txtValue = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
		[txtValue setBackgroundColor:[UIColor whiteColor]];
		[txtValue setAutocorrectionType:_intOtherTextAutocorrectionType];
		[txtValue setAutocapitalizationType:_intOtherTextAutocapitalizationType];
		
		if (_blnMultipleSelectFlag) {
			[txtValue setText:_strOtherValue];
		} else {
			if ([tableView cellForRowAtIndexPath:indexPath].isSelected) {
				[txtValue setText:_strSingleValue];
			}
		}
		
        [txtValue addTarget:self 
					 action:@selector(textFieldDone:) 
		   forControlEvents:UIControlEventEditingDidEndOnExit];
		
		[_objAlertView addSubview:txtValue];
		[_objAlertView show];
		[txtValue release];
		return nil;
	} else {
		if (_blnMultipleSelectFlag) {
			if ([(NSNumber *)[_blnSelectedArray objectAtIndex:[indexPath row]] boolValue]) {
				[_blnSelectedArray replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:false]];
			} else {
				[_blnSelectedArray replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:true]];
			}
		} else {
			if ([_strSingleValue isEqualToString:(NSString *)[_strValueArray objectAtIndex:[indexPath row]]]) {
				[self setSingleValue:nil];
			} else {
				[self setSingleValue:[_strValueArray objectAtIndex:[indexPath row]]];
			}
		}
		[tableView reloadData];
		return nil;
	}
}*/


@end