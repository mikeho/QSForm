/**
 * QSTextViewFormItem.m
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

@implementation QSTextViewFormItem

@synthesize _strValue;
@synthesize _blnPasswordFlag;
@synthesize _intAutocorrectionType;
@synthesize _intAutocapitalizationType;


- (QSTextViewFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(NSString *)strValue {
	if (self = (QSTextViewFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_strValue = strValue;
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
        txtField = [[UITextField alloc] initWithFrame:CGRectMake(94, 10, 200, 25)];
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
		[txtField release];
    } else {
		txtField = nil;
		for (UIView * objView in objCell.contentView.subviews) {
			if ([objView isMemberOfClass:[UITextField class]])
				txtField = (UITextField*)objView;
		}
	}
	
	txtField.text = _strValue;
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
	[_objForm setSelectedIndexPath:_objIndexPath];
}

- (IBAction)textFieldDone:(id)sender {
	_strValue = [NSString stringWithString:((UITextField *)sender).text];
	[_strValue retain];
}

@end
