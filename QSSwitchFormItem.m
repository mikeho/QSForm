/**
 * QSSwitchFormItem.m
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

@implementation QSSwitchFormItem

@synthesize _blnValue;
@synthesize _blnValueExists;
@synthesize _strOverrideOnLabel;
@synthesize _strOverrideOffLabel;

- (QSSwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(bool)blnValue {
	if (self = (QSSwitchFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_blnValue = blnValue;
		_blnValueExists = true;
	}
	return self;
}

- (QSSwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel WithNullValue:(id)objNull {
	if (self = (QSSwitchFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_blnValue = false;
		_blnValueExists = false;
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	UISwitch * chkField;
	UIButton * imgUnanswered;

	if (_blnCreatedFlag) {
		chkField = [[UISwitch alloc] initWithFrame:[self getControlFrameWithHeight:0]];
		chkField.tag = _intIndex;
		[objCell.contentView addSubview:chkField];
		[chkField addTarget:self
					 action:@selector(chkFieldTap:)
		   forControlEvents:UIControlEventValueChanged];
		[chkField release];

		imgUnanswered = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[imgUnanswered setFrame:[self getControlFrameWithWidth:94 Height:27]];
		[imgUnanswered setTag:_intIndex + 1];
		[imgUnanswered setBackgroundImage:[UIImage imageNamed:@"switchUnanswered.png"] forState:UIControlStateNormal];
		[imgUnanswered addTarget:self action:@selector(unansweredClick:) forControlEvents:UIControlEventTouchUpInside];
		[objCell.contentView addSubview:imgUnanswered];
    } else {
		chkField = nil;
		imgUnanswered = nil;
		for (UIView * objView in objCell.contentView.subviews) {
			if ([objView isMemberOfClass:[UISwitch class]])
				chkField = (UISwitch *)objView;
			else if ([objView tag] == _intIndex + 1)
				imgUnanswered = (UIButton *)objView;
		}
	}
	
	chkField.on = _blnValue;
	[imgUnanswered setHidden:_blnValueExists];

	if (_strOverrideOnLabel) {
		UILabel * lblLeft = [[[[[[chkField subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:0];
		[lblLeft setText:_strOverrideOnLabel];
	}

	if (_strOverrideOffLabel) {
		UILabel * lblRight = [[[[[[chkField subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:1];
		[lblRight setText:_strOverrideOffLabel];
	}

	return objCell;
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {
//	_blnChangedFlag = true;
//	bool blnNewValue = !(((UISwitch *)[objCell.contentView viewWithTag:_intIndex]).on);
//	[(UISwitch *)[objCell.contentView viewWithTag:_intIndex] setOn:blnNewValue animated:true];
	return false;
}

- (IBAction)unansweredClick:(id)sender {
	_blnChangedFlag = true;
	_blnValueExists = true;
	[_objForm redraw];
	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (IBAction)chkFieldTap:(id)sender {
	_blnChangedFlag = true;
	_blnValue = ((UISwitch *)sender).on;
	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (void)dealloc {
	[self OverrideOnLabel:nil];
	[self OverrideOffLabel:nil];
	[super dealloc];
}

@end