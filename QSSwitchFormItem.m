//
//  SwitchFormItem.m
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import "SwitchFormItem.h"


@implementation SwitchFormItem

@synthesize _blnValue;
@synthesize _blnValueExists;
@synthesize _strOverrideOnLabel;
@synthesize _strOverrideOffLabel;

- (SwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(bool)blnValue {
	if (self = (SwitchFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_blnValue = blnValue;
		_blnValueExists = true;
	}
	return self;
}

- (SwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel WithNullValue:(id)objNull {
	if (self = (SwitchFormItem *)[super initWithKey:strKey Label:strLabel]) {
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