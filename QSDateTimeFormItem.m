/**
 * QSDateTimeFormItem.m
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

@implementation QSDateTimeFormItem

@synthesize _dttValue;
@synthesize _blnTimeFlag;
@synthesize _strDateTimeFormat;


- (QSDateTimeFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(NSDate *)dttValue {
	if (self = (QSDateTimeFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_dttValue = dttValue;
		[_dttValue retain];
		
		_blnTimeFlag = true;
		_strDateTimeFormat = @"MMM d 'at' h:mma";
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	UILabel * lblField;

	if (_blnCreatedFlag) {
		lblField = [[UILabel alloc] initWithFrame:[self getControlFrameWithoutPaddingWithHeight:23]];
		[lblField autorelease];
		[lblField setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
		[lblField setBackgroundColor:[UIColor clearColor]];
		[objCell.contentView addSubview:lblField];
    } else {
		lblField = nil;
		for (UIView * objView in objCell.contentView.subviews) {
			if ([objView isMemberOfClass:[UILabel class]])
				lblField = (UILabel *)objView;
		}
	}

	NSDateFormatter * objFormatter = [[NSDateFormatter alloc] init];
	[objFormatter setDateFormat:_strDateTimeFormat];
	[lblField setText:[objFormatter stringFromDate:_dttValue]];
	[objFormatter release];

	return objCell;
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {
	UIActionSheet * objSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n\n\n\n\n\n\n", _strLabel]
														   delegate:self
												  cancelButtonTitle:@"Cancel"
											 destructiveButtonTitle:nil
												  otherButtonTitles:@"OK", nil];

	// Add the picker
	_objPicker = [[UIDatePicker alloc] init];
	[_objPicker setDatePickerMode:UIDatePickerModeDateAndTime];
	if (!_blnTimeFlag) {
		[_objPicker setDatePickerMode:UIDatePickerModeDate];
	}

	if (_dttValue == nil)
		[_objPicker setDate:[NSDate date]];
	else
		[_objPicker setDate:_dttValue];
	
	CGRect objRect = [_objPicker frame];
	objRect.origin.y += 40;
	[_objPicker setFrame:objRect];

	[objSheet addSubview:_objPicker];

	[objSheet showInView:[_objForm view]];
	[objSheet release];

	return false;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self setValue:[_objPicker date]];
		_blnChangedFlag = true;
		[_objForm redraw];
	}
	
	[_objPicker release];
	_objPicker = nil;
}

- (void)dealloc {
	[self setValue:nil];
	[self setDateTimeFormat:nil];
	[_objPicker release];
	_objPicker = nil;
	[super dealloc];
}

@end
