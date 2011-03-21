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
@synthesize _strSwitchOnImage;
@synthesize _strSwitchOffImage;
@synthesize _strSwitchBlankImage;

- (QSSwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(bool)blnValue {
	if (self = (QSSwitchFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_blnValue = blnValue;
		_blnValueExists = true;
		_blnAllowBlankResponse = false;
		
		_strSwitchOnImage = @"QSSwitchOn.png";
		_strSwitchOffImage = @"QSSwitchOff.png";
		_strSwitchBlankImage = @"QSSwitchBlank.png";
	}

	return self;
}

- (QSSwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel WithNullValue:(id)objNull {
	if (self = (QSSwitchFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_blnValue = false;
		_blnValueExists = false;
		_blnAllowBlankResponse = false;
		
		_strSwitchOnImage = @"QSSwitchOn.png";
		_strSwitchOffImage = @"QSSwitchOff.png";
		_strSwitchBlankImage = @"QSSwitchBlank.png";
	}

	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	UIButton * btnSwitch;

	if (_blnCreatedFlag) {
		btnSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
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
	

	UIImage * imgToUse;

	if (_blnValueExists) {
		if (_blnValue) {
			imgToUse = [UIImage imageNamed:_strSwitchOnImage];
		} else {
			imgToUse = [UIImage imageNamed:_strSwitchOffImage];
		}
	} else {
		imgToUse = [UIImage imageNamed:_strSwitchBlankImage];
	}
	
	// Set the image
	[btnSwitch setBackgroundImage:imgToUse forState:UIControlStateNormal];
	
	// Adjust btn size
	CGRect objFrame = [self getControlFrameWithWidth:imgToUse.size.width Height:imgToUse.size.height];
	objFrame.origin.y -= 4;
	[btnSwitch setFrame:objFrame];

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

	UIImage * imgToUse;
	
	if (_blnValueExists) {
		if (_blnValue) {
			imgToUse = [UIImage imageNamed:_strSwitchOnImage];
		} else {
			imgToUse = [UIImage imageNamed:_strSwitchOffImage];
		}
	} else {
		imgToUse = [UIImage imageNamed:_strSwitchBlankImage];
	}
	
	// Set the image
	[btnSwitch setBackgroundImage:imgToUse forState:UIControlStateNormal];
	
	// Adjust btn size
	CGRect objFrame = [self getControlFrameWithWidth:imgToUse.size.width Height:imgToUse.size.height];
	objFrame.origin.y -= 4;
	[btnSwitch setFrame:objFrame];

	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (void)dealloc {
	[_strSwitchOnImage release];
	[_strSwitchOffImage release];
	[_strSwitchBlankImage release];
	[super dealloc];
}

@end