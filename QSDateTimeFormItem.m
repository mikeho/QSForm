//
//  DateTimeFormItem.m
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import "DateTimeFormItem.h"
#import <UIKit/UITableView.h>

@implementation DateTimeFormItem

@synthesize _dttValue;
@synthesize _blnTimeFlag;
@synthesize _strDateTimeFormat;


- (DateTimeFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(NSDate *)dttValue {
	if (self = (DateTimeFormItem *)[super initWithKey:strKey Label:strLabel]) {
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
		[self Value:[_objPicker date]];
		[_objForm redraw];
	}
	
	[_objPicker release];
	_objPicker = nil;
}

- (void)dealloc {
	[self Value:nil];
	[self DateTimeFormat:nil];
	[_objPicker release];
	_objPicker = nil;
	[super dealloc];
}

@end
