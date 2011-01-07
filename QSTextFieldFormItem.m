//
//  TextFieldFormItem.m
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import "TextFieldFormItem.h"
#import <UIKit/UITableView.h>
#import "Constants.h"

@implementation TextFieldFormItem

@synthesize _strValue;
@synthesize _blnPasswordFlag;
@synthesize _intAutocorrectionType;
@synthesize _intAutocapitalizationType;


- (TextFieldFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(NSString *)strValue {
	if (self = (TextFieldFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_strValue = strValue;
		[_strValue retain];
		_blnPasswordFlag = false;
		_intAutocorrectionType = UITextAutocorrectionTypeDefault;
		_intAutocapitalizationType = UITextAutocapitalizationTypeSentences;
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	UITextField * txtField;

	if (_blnCreatedFlag) {
        txtField = [[UITextField alloc] initWithFrame:[self getControlFrameWithHeight:0]];
        txtField.tag = _intIndex;
        txtField.clearsOnBeginEditing = NO;
		[txtField addTarget:self
					 action:@selector(textFieldStart:)
		   forControlEvents:UIControlEventEditingDidBegin];
        [txtField addTarget:self 
					 action:@selector(textFieldDone:) 
		   forControlEvents:UIControlEventEditingDidEndOnExit];
        [txtField addTarget:self 
					 action:@selector(textFieldDone:) 
		   forControlEvents:UIControlEventEditingDidEnd];
		[objCell.contentView addSubview:txtField];
		[txtField autorelease];
    } else {
		txtField = nil;
		for (UIView * objView in objCell.contentView.subviews) {
			if ([objView isMemberOfClass:[UITextField class]])
				txtField = (UITextField*)objView;
		}
	}
	
	[txtField setPlaceholder:_strLabel];
	[txtField setText:_strValue];
	txtField.secureTextEntry = _blnPasswordFlag;
	txtField.autocorrectionType = _intAutocorrectionType;
	txtField.autocapitalizationType = _intAutocapitalizationType;

	return objCell;
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {
	UITextField * txtField = (UITextField *)[objCell.contentView viewWithTag:_intIndex];
	[txtField becomeFirstResponder];
	return true;
}

- (void)tableViewCellUnselect:(UITableViewCell *)objCell {
	UITextField * txtField = (UITextField *)[objCell.contentView viewWithTag:_intIndex];
	[txtField endEditing:true];
}

- (IBAction)textFieldStart:(id)sender {
	[_objForm SelectedIndexPath:_objIndexPath];
}

- (IBAction)textFieldDone:(id)sender {
	_blnChangedFlag = true;
	[_objForm SelectedIndexPath:nil];
	[self Value:[NSString stringWithString:((UITextField *)sender).text]];
}

- (void)dealloc {
	[self Value:nil];
	[super dealloc];
}

@end
