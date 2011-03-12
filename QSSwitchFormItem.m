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
@synthesize _blnAllowBlankResponse;

- (QSSwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(bool)blnValue {
	if (self = (QSSwitchFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_blnValue = blnValue;
		_blnValueExists = true;
		_blnAllowBlankResponse = false;
	}
	NSLog(@"Constructor called for %@ with %i", strLabel, blnValue);
	return self;
}

- (QSSwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel WithNullValue:(id)objNull {
	if (self = (QSSwitchFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_blnValue = false;
		_blnValueExists = false;
		_blnAllowBlankResponse = false;
	}

	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	UIButton * btnSwitch;

	if (_blnCreatedFlag) {
		btnSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
		CGRect objFrame = [self getControlFrameWithWidth:27 Height:27];
		objFrame.origin.y -= 4;
		[btnSwitch setFrame:objFrame];
		btnSwitch.tag = _intIndex;
		[objCell.contentView addSubview:btnSwitch];
		[btnSwitch addTarget:self action:@selector(chkFieldTap:) forControlEvents:UIControlEventTouchUpInside];
    } else {
		btnSwitch = nil;
		for (UIView * objView in objCell.contentView.subviews) {
			if (objView.tag == _intIndex)
				btnSwitch = (UIButton *)objView;
		}
	}
	
	if (_blnValueExists) {
		if (_blnValue) {
			[btnSwitch setBackgroundImage:[UIImage imageNamed:@"QSSwitchOn.png"] forState:UIControlStateNormal];
		} else {
			[btnSwitch setBackgroundImage:[UIImage imageNamed:@"QSSwitchOff.png"] forState:UIControlStateNormal];
		}
	} else {
		[btnSwitch setBackgroundImage:[UIImage imageNamed:@"QSSwitchBlank.png"] forState:UIControlStateNormal];
	}
	
	return objCell;
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {
	UIButton * btnSwitch = (UIButton *)[[objCell contentView] viewWithTag:_intIndex];
	[self chkFieldTap:btnSwitch];
	return false;
}

- (IBAction)chkFieldTap:(id)sender {
	_blnChangedFlag = true;

	if (_blnValueExists) {
		if (_blnValue) {
			_blnValue = false;
		} else if (_blnAllowBlankResponse) {
			_blnValueExists = false;
		} else {
			_blnValue = true;
		}
	} else {
		_blnValueExists = true;
		_blnValue = true;
	}
	

	UIButton * btnSwitch = (UIButton *)sender;

	if (_blnValueExists) {
		if (_blnValue) {
			[btnSwitch setBackgroundImage:[UIImage imageNamed:@"QSSwitchOn.png"] forState:UIControlStateNormal];
		} else {
			[btnSwitch setBackgroundImage:[UIImage imageNamed:@"QSSwitchOff.png"] forState:UIControlStateNormal];
		}
	} else {
		[btnSwitch setBackgroundImage:[UIImage imageNamed:@"QSSwitchBlank.png"] forState:UIControlStateNormal];
	}

	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (void)dealloc {
	[super dealloc];
}

@end