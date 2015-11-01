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

@implementation QSListFormItem

@synthesize _strSingleValue;
@synthesize _blnAllowOtherFlag;
@synthesize _blnDisplayMultiLineFlag;
@synthesize _objBackgroundColor;
@synthesize _objAlternateBackgroundColor;
@synthesize _intOtherTextAutocorrectionType;
@synthesize _intOtherTextAutocapitalizationType;

#pragma mark -
#pragma mark Initializers

- (QSListFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel SingleValue:(NSString *)strSingleValue {
	if (self = (QSListFormItem *)[super initWithKey:strKey Label:strLabel]) {
		if ([strSingleValue length] > 0) {
			_strSingleValue = strSingleValue;
			[_strSingleValue retain];
		} else {
			_strSingleValue = nil;
		}
		_strNameArray = [[NSMutableArray alloc] init];
		_strValueArray = [[NSMutableArray alloc] init];
		
		_blnAllowOtherFlag = false;
		_blnMultipleSelectFlag = false;
		_intOtherTextAutocorrectionType = UITextAutocorrectionTypeNo;
		_intOtherTextAutocapitalizationType = UITextAutocapitalizationTypeNone;
	}
	return self;
}

- (QSListFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel MultipleValue:(NSArray *)strMultipleValueArray {
	if (self = (QSListFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_strMultipleValueArray = [[NSMutableArray alloc] initWithArray:strMultipleValueArray];

		_strNameArray = [[NSMutableArray alloc] init];
		_strValueArray = [[NSMutableArray alloc] init];
		_blnSelectedArray = [[NSMutableArray alloc] init];

		_strOtherValue = [QSStrings implodeArray:_strMultipleValueArray WithGlue:@", "];
		[_strOtherValue retain];

		_blnAllowOtherFlag = false;
		_blnMultipleSelectFlag = true;
		_intOtherTextAutocorrectionType = UITextAutocorrectionTypeNo;
		_intOtherTextAutocapitalizationType = UITextAutocapitalizationTypeNone;
	}
	return self;
}

- (bool)getMultipleSelectFlag {
    return _blnMultipleSelectFlag;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[self setSingleValue:nil];
	[self setBackgroundColor:nil];
	[self setAlternateBackgroundColor:nil];
	[_strNameArray release];
	[_strValueArray release];
	[_blnSelectedArray release];
	[_strMultipleValueArray release];
	[_strOtherValue release];

    [_lblField setText:nil];
	[_lblField release];
	[_objTableViewController release];
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

	if (_blnMultipleSelectFlag) {
		NSMutableArray * strSelectedValueArray = [[NSMutableArray alloc] init];
		for (NSString * strSelectedValue in [self multipleValueArray]) {
			for (NSInteger intIndex = 0; intIndex < [_strValueArray count]; intIndex++) {
				NSString * strValue = (NSString *)[_strValueArray objectAtIndex:intIndex];
				NSString * strName = (NSString *)[_strNameArray objectAtIndex:intIndex];
				
				if ([strSelectedValue isEqualToString:strValue]) {
					strSelectedValue = strName;
				}
			}
			
			[strSelectedValueArray addObject:strSelectedValue];
		}
		[_lblField setText:[QSStrings implodeArray:strSelectedValueArray WithGlue:@"\n"]];
		[strSelectedValueArray release];
	} else {
		[_lblField setText:_strSingleValue];
		
		for (NSInteger intIndex = 0; intIndex < [_strValueArray count]; intIndex++) {
			NSString * strValue = (NSString *)[_strValueArray objectAtIndex:intIndex];
			NSString * strName = (NSString *)[_strNameArray objectAtIndex:intIndex];
			
			if ([strValue isEqualToString:_strSingleValue]) {
				[_lblField setText:strName];
			}
		}
		
	}
	
	if ([_lblField text] == nil) {
		[_lblField setText:@"Tap to Add"];
		[_lblField setTextColor:[UIColor grayColor]];
		[_lblField setFont:[UIFont italicSystemFontOfSize:[UIFont systemFontSize]]];
	} else {
		[_lblField setTextColor:[UIColor blackColor]];
		[_lblField setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
	}

	// Setup the Height
	CGRect objFrame = [_lblField frame];
	objFrame.size.height = 1000;
	[_lblField setFrame:objFrame];
	[QSLabels trimFrameHeightForLabel:_lblField WithMinHeight:25];
	return fmax([super getHeight], kLabelTopMargin + _lblField.bounds.size.height + kLabelBottomMargin);
}

- (CGFloat)getHeight {
	CGFloat fltToReturn = [self refreshImageView];
	if (_blnHiddenFlag) return 0;
	return fltToReturn;
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {
	_objTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
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

- (void)addItemWithName:(NSString *)strName {
	[self addItemWithName:strName Value:strName];
}

- (void)addItemWithName:(NSString *)strName IntegerValue:(NSInteger)intValue {
	[self addItemWithName:strName Value:[NSString stringWithFormat:@"%d", intValue]];
}

- (void)addItemWithName:(NSString *)strName Value:(NSString *)strValue {
	[_strNameArray addObject:strName];
	[_strValueArray addObject:strValue];

	if (_blnMultipleSelectFlag) {
		NSString * strFoundSelectedValue = nil;
		for (NSString * strSelectedValue in _strMultipleValueArray) {
			if ([strSelectedValue isEqualToString:strValue]) {
				strFoundSelectedValue = strSelectedValue;
			}
		}

		// Update the "Selected" Array
		if (strFoundSelectedValue == nil) {
			[_blnSelectedArray addObject:[NSNumber numberWithBool:false]];
		} else {
			[_blnSelectedArray addObject:[NSNumber numberWithBool:true]];
			[_strMultipleValueArray removeObjectIdenticalTo:strFoundSelectedValue];
		}

		// Update the "Other" Value (if applicable)
		if ([_strMultipleValueArray count]) {
			[_strOtherValue release];
			_strOtherValue = [QSStrings implodeArray:_strMultipleValueArray WithGlue:@", "];
			[_strOtherValue retain];
		} else {
			[_strOtherValue release];
			_strOtherValue = nil;
		}
	}
}

- (void)setMultipleValueArray:(NSArray *)strMultipleValueArray {
	if (_strMultipleValueArray) {
		[_strMultipleValueArray release];
		_strMultipleValueArray = nil;
	}
	
	_strMultipleValueArray = [[NSMutableArray alloc] initWithArray:strMultipleValueArray copyItems:true];
}

- (NSArray *)multipleValueArray {
	if (!_blnMultipleSelectFlag) NSAssert(false, @"Cannot ask for MultipleValues on a single-select List");

	// Add each selected value from the arrays
	NSMutableArray * strSelectedValueArray = [[[NSMutableArray alloc] init] autorelease];
	for (NSInteger intIndex = 0; intIndex < [_blnSelectedArray count]; intIndex++) {
		if ([(NSNumber *)[_blnSelectedArray objectAtIndex:intIndex] boolValue])
			[strSelectedValueArray addObject:[_strValueArray objectAtIndex:intIndex]];
	}

	// Add the "other" if applicable
	if (_blnAllowOtherFlag && (_strOtherValue != nil)) {
		[strSelectedValueArray addObject:_strOtherValue];
	}

	return [NSArray arrayWithArray:strSelectedValueArray];
}

- (void)removeAllItems {
	[_strNameArray release];
	_strNameArray = nil;
	[_strValueArray release];
	_strValueArray= nil;
	[_blnSelectedArray release];
	_blnSelectedArray = nil;

	_strNameArray = [[NSMutableArray alloc] init];
	_strValueArray = [[NSMutableArray alloc] init];
	if (_blnMultipleSelectFlag)
		_blnSelectedArray = [[NSMutableArray alloc] init];
}

- (NSString *)otherValueString {
	return _strOtherValue;
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_strNameArray count] + (_blnAllowOtherFlag ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * strIdentifier = @"listFormItemCellIdentifier";
	UITableViewCell * objCell = [[_objTableViewController tableView] dequeueReusableCellWithIdentifier:strIdentifier];

    if (objCell == nil) {
		objCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier] autorelease];
	}

	[[objCell textLabel] setBackgroundColor:[UIColor clearColor]];

	if (_blnDisplayMultiLineFlag) {
		[[objCell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
		[[objCell textLabel] setNumberOfLines:0];
	}
	
	if (_blnAllowOtherFlag && ([indexPath row] == [_strNameArray count])) {
		NSString * strOtherText;
		
		if (_blnMultipleSelectFlag) {
			strOtherText = _strOtherValue;
		} else {
			strOtherText = _strSingleValue;
			for (NSInteger intIndex = 0; (intIndex < [_strNameArray count]) && (strOtherText != nil); intIndex++) {
				if ([_strSingleValue isEqualToString:[_strValueArray objectAtIndex:intIndex]]) {
					strOtherText = nil;
				}
			}
		}

		if (strOtherText == nil) {
			[[objCell textLabel] setText:@"Other..."];
			[[objCell textLabel] setTextColor:[UIColor grayColor]];
			[[objCell textLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]];
            
            if (_blnMultipleSelectFlag) {
                // Set background color (if applicable)
                if (_objBackgroundColor != nil) {
                    if (([indexPath row] % 2) && _objAlternateBackgroundColor) {
                        [[objCell contentView] setBackgroundColor:_objAlternateBackgroundColor];
                    } else {
                        [[objCell contentView] setBackgroundColor:_objBackgroundColor];
                    }
                }
            } else {
                [tableView deselectRowAtIndexPath:indexPath animated:false];
            }
		} else {
			[[objCell textLabel] setText:strOtherText];
            
            if (_blnMultipleSelectFlag) {
                [[objCell textLabel] setTextColor:[UIColor whiteColor]];
                [[objCell contentView] setBackgroundColor:[UIColor colorWithRed:0.0f green:0.35f blue:.90f alpha:1.0f]];
            } else {
                [tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
            }
		}
	} else {
		[[objCell textLabel] setText:[_strNameArray objectAtIndex:[indexPath row]]];

		// Adjust font size
		if (_blnDisplayMultiLineFlag) {
			UILabel * lblText = [objCell textLabel];
			CGFloat fltPointSize = [UIFont labelFontSize];
			CGRect objFrame;
			
			[lblText setFont:[UIFont boldSystemFontOfSize:fltPointSize]];
			objFrame = [lblText frame];
			objFrame.size.width = [UIScreen mainScreen].bounds.size.width - 40;
			objFrame.size.height = 1000;
			[lblText setFrame:objFrame];
			[QSLabels trimFrameHeightForLabel:lblText WithMinHeight:40];
			
			while ([lblText frame].size.height > 40) {
				fltPointSize -= 1.0f;
				[lblText setFont:[UIFont boldSystemFontOfSize:fltPointSize]];
				objFrame = [lblText frame];
				objFrame.size.height = 1000;
				[lblText setFrame:objFrame];
				[QSLabels trimFrameHeightForLabel:lblText WithMinHeight:40];
			}
			[objCell setNeedsLayout];
			[objCell setNeedsDisplay];
		}
        
		if (_blnMultipleSelectFlag) {
			if ([(NSNumber *)[_blnSelectedArray objectAtIndex:[indexPath row]] boolValue]) {
                [[objCell textLabel] setTextColor:[UIColor whiteColor]];
                [[objCell contentView] setBackgroundColor:[UIColor colorWithRed:0.0f green:0.35f blue:.90f alpha:1.0f]];
			} else {
                [[objCell textLabel] setTextColor:[UIColor blackColor]];
                // Set background color (if applicable)
                if (_objBackgroundColor != nil) {
                    if (([indexPath row] % 2) && _objAlternateBackgroundColor) {
                        [[objCell contentView] setBackgroundColor:_objAlternateBackgroundColor];
                    } else {
                        [[objCell contentView] setBackgroundColor:_objBackgroundColor];
                    }
                }
			}
		} else {
            [[objCell textLabel] setTextColor:[UIColor blackColor]];
            // Set background color (if applicable)
            if (_objBackgroundColor != nil) {
                if (([indexPath row] % 2) && _objAlternateBackgroundColor) {
                    [[objCell contentView] setBackgroundColor:_objAlternateBackgroundColor];
                } else {
                    [[objCell contentView] setBackgroundColor:_objBackgroundColor];
                }
            }

			if ([_strSingleValue isEqualToString:[_strValueArray objectAtIndex:[indexPath row]]]) {
				[tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
			} else {
				[tableView deselectRowAtIndexPath:indexPath animated:false];
			}
		}
	}

    return objCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_blnChangedFlag = true;

	if (_blnAllowOtherFlag && ([indexPath row] == [_strNameArray count])) {
		_objAlertView = [[UIAlertView alloc] initWithTitle:@"Other..." message:@" " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        // Adding subviews to the UIAlertView is no longer supported in iOS7+, so just create the
        // UIAlertView with a text input style.
        [_objAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField * txtValue = [_objAlertView textFieldAtIndex:0];
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
		
		[_objAlertView show];
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
}

#pragma mark -
#pragma mark "Other" Option Management

- (IBAction)textFieldDone:(id)sender {
	[_objAlertView dismissWithClickedButtonIndex:1 animated:true];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	UITextField * txtValue = [alertView textFieldAtIndex:0];

	if (buttonIndex == 0) {
		// Do Nothing
	} else {
		if (_blnMultipleSelectFlag) {
			if ([[txtValue text] length] > 0) {
				[_strOtherValue release];
				_strOtherValue = [txtValue text];
				[_strOtherValue retain];
			} else {
				[_strOtherValue release];
				_strOtherValue = nil;
			}
		} else {
			if ([[txtValue text] length] > 0) {
				[self setSingleValue:[txtValue text]];
			} else {
				[self setSingleValue:nil];
			}
		}
		
		[[_objTableViewController tableView] reloadData];
	}

	[_objAlertView release];
	_objAlertView = nil;
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
	for (UIView * objSubview in [alertView subviews]) {
		if ([objSubview isMemberOfClass:[UITextField class]]) {
			[objSubview becomeFirstResponder];
		}
	}
}

@end