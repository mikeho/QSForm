/**
 * QSTextFieldFormItem.m
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

static CGRect _TextFieldFormItem_objCurrentFrame;
static CGSize _TextFieldFormItem_objCurrentContentSize;
static CGPoint _TextFieldFormItem_objCurrentContentOffset;
static bool _TextFieldFormItem_blnCurrentScrollEnableFlag;
static bool _TextFieldFormItem_blnIsScrollingFlag;
static bool _TextFieldFormItem_blnIsCleaningUpFlag;

@implementation QSTextFieldFormItem

@synthesize _strValue;
@synthesize _blnPasswordFlag;
@synthesize _blnDisplayMultiLineFlag;
@synthesize _intAutocorrectionType;
@synthesize _intAutocapitalizationType;
@synthesize _intKeyboardType;



- (QSTextFieldFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(NSString *)strValue {
	if (self = (QSTextFieldFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_strValue = strValue;
		[_strValue retain];
		_blnPasswordFlag = false;
		_blnDisplayMultiLineFlag = false;
		_intAutocorrectionType = UITextAutocorrectionTypeDefault;
		_intAutocapitalizationType = UITextAutocapitalizationTypeSentences;
		_intKeyboardType = UIKeyboardTypeDefault;
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	if ([[objCell subviews] indexOfObject:_txtField] == NSNotFound) {
		[objCell.contentView addSubview:_txtField];
		[objCell.contentView addSubview:_lblField];
	}

	if (_blnDisplayMultiLineFlag) {
		if ([_strValue length]) {
			[_txtField setHidden:true];
			[_lblField setHidden:false];
		} else {
			[_txtField setHidden:false];
			[_lblField setHidden:true];
		}
	} else {
		[_txtField setHidden:false];
		[_lblField setHidden:true];
	}

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
	[self keyboardWillShow:self];
	
	// Swap Displays
	[_lblField setHidden:true];
	[_txtField setHidden:false];
}

- (IBAction)textFieldDone:(id)sender {
	_blnChangedFlag = true;
	[_objForm setSelectedIndexPath:nil];
	[self setValue:[NSString stringWithString:((UITextField *)sender).text]];
	[self keyboardWillHide:self];
	
	if (_blnDisplayMultiLineFlag) [_objForm redraw];
}

- (CGFloat)getHeight {
	// Create UITextField if it has not yet been created
	// Configure events handling on it as well
	if (_txtField == nil) {
        _txtField = [[UITextField alloc] initWithFrame:[self getControlFrameWithHeight:0]];
        _txtField.tag = _intIndex;
        _txtField.clearsOnBeginEditing = NO;
		[_txtField addTarget:self
					  action:@selector(textFieldStart:)
			forControlEvents:UIControlEventEditingDidBegin];
        [_txtField addTarget:self 
					  action:@selector(textFieldDone:) 
			forControlEvents:UIControlEventEditingDidEndOnExit];
        [_txtField addTarget:self 
					  action:@selector(textFieldDone:) 
			forControlEvents:UIControlEventEditingDidEnd];
	}

	// Create UILabel (to display it as multiline if requested) if not yet created
	if (_lblField == nil) {
		_lblField = [[UILabel alloc] initWithFrame:[self getControlFrameWithHeight:0]];
		_lblField.tag = _intIndex + 1;
		
		[_lblField setBackgroundColor:[UIColor clearColor]];
		[_lblField setNumberOfLines:0];
		[_lblField setLineBreakMode:UILineBreakModeWordWrap];
	}

	// Update TextField properties
	[_txtField setPlaceholder:_strLabel];
	[_txtField setText:_strValue];
	_txtField.secureTextEntry = _blnPasswordFlag;
	_txtField.autocorrectionType = _intAutocorrectionType;
	_txtField.autocapitalizationType = _intAutocapitalizationType;
	_txtField.keyboardType = _intKeyboardType;

	// Update UILabel Properties (including Height)
	[_lblField setText:_strValue];
	CGRect objFrame = [_lblField frame];
	objFrame.size.height = 5000;
	[_lblField setFrame:objFrame];
	[QSLabels trimFrameHeightForLabel:_lblField];

	if (_blnDisplayMultiLineFlag) {
		return MAX([super getHeight], _lblField.frame.size.height + kTopMargin*2);
	} else {
		return [super getHeight];
	}
}

#pragma mark -
#pragma mark Keyboard and Scroll Management


- (void)resetScrollingStep1 {
	if (_TextFieldFormItem_blnIsCleaningUpFlag) {
		if ((_objForm) && ([_objForm navigatedViewController]) && ([[_objForm navigatedViewController] view])) {
			UIScrollView * objScrollView = (UIScrollView *)[[_objForm navigatedViewController] view];
			[objScrollView setFrame:_TextFieldFormItem_objCurrentFrame];
			[objScrollView setContentOffset:_TextFieldFormItem_objCurrentContentOffset animated:true];
	
			[self performSelector:@selector(resetScrollingStep2) withObject:nil afterDelay:0.3];
		}
		_TextFieldFormItem_blnIsScrollingFlag = false;
		_TextFieldFormItem_blnIsCleaningUpFlag = false;
	}
}

- (void)resetScrollingStep2 {
	UIScrollView * objScrollView = (UIScrollView *)[[_objForm navigatedViewController] view];
	[objScrollView setScrollEnabled:_TextFieldFormItem_blnCurrentScrollEnableFlag];
	[objScrollView setContentSize:_TextFieldFormItem_objCurrentContentSize];
}

- (void)keyboardWillHide:(id)sender {
	if (_objForm.suspendScrollRestoreFlag) return;
	
	[self performSelector:@selector(resetScrollingStep1) withObject:nil afterDelay:0.1];
	_TextFieldFormItem_blnIsCleaningUpFlag = true;
}

- (void)keyboardWillShow:(id)sender {
	if (_objForm.suspendScrollRestoreFlag) {
		[_objForm setSuspendScrollRestoreFlag:false];
		return;
	}
	
	UIScrollView * objScrollView = (UIScrollView *)[_objForm.navigatedViewController view];

	CGFloat fltYPosition = [_objForm getYPositionForCellAtIndexPath:_objForm.selectedIndexPath];
	fltYPosition -= kTopMargin;

	// Are we "already scrolling"?  If not, let's store the current ScrollView data
	if (!_TextFieldFormItem_blnIsScrollingFlag) {
		_TextFieldFormItem_objCurrentFrame = [objScrollView frame];
		_TextFieldFormItem_objCurrentContentSize = [objScrollView contentSize];
		_TextFieldFormItem_objCurrentContentOffset = [objScrollView contentOffset];
		_TextFieldFormItem_blnCurrentScrollEnableFlag = [objScrollView isScrollEnabled];
		_TextFieldFormItem_blnIsScrollingFlag = true;
	}
	_TextFieldFormItem_blnIsCleaningUpFlag = false;

	CGFloat fltHeight;
	if ([[_objForm.navigatedViewController navigationItem] prompt] == nil) {
		fltHeight = 200;
	} else {
		fltHeight = 170;
	}
	
	[UIView beginAnimations:@"" context:NULL];
	[objScrollView setFrame:CGRectMake(_TextFieldFormItem_objCurrentFrame.origin.x, _TextFieldFormItem_objCurrentFrame.origin.y, [UIScreen mainScreen].bounds.size.width, fltHeight)];
	[UIView commitAnimations];
	
	[objScrollView setScrollEnabled:true];
	[objScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 5000)];
	
	CGRect objRectToScrollTo = CGRectMake(0, fltYPosition, [UIScreen mainScreen].bounds.size.width, [[_objForm getFormItemAtIndex:[_objForm.selectedIndexPath row]] getHeight] + kTopMargin*2);
	[objScrollView scrollRectToVisible:objRectToScrollTo
							  animated:true];
}

#pragma mark -
#pragma mark Object Lifecycle

- (void)dealloc {
	[self setValue:nil];
	[_lblField release];
	[_txtField release];
	[super dealloc];
}

@end
