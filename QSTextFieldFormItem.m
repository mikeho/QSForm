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
@synthesize _activeField;



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
    
    _activeField = false;
    
    // Register the notification for when the keyboard will be shown
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register the notification for when the keyboard will be hidden
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
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

- (IBAction)textFieldEdit:(id)sender {
    [self setValue:_txtField.text];
}

- (IBAction)textFieldStart:(id)sender {
    _activeField = true;
    [_objForm setSelectedIndexPath:_objIndexPath];
    
    // Only do this for the iOS6 versions.  iOS7+ uses the keyboard notifications instead.
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer hasPrefix:@"6"]) {
        [self keyboardWillShow:self];
    }
	
	// Swap Displays
	[_lblField setHidden:true];
	[_txtField setHidden:false];
	
	// Perform Delegates (if applicable)
	if (([_objForm delegate] != nil) && ([[_objForm delegate] respondsToSelector:@selector(form:didSelectFormItem:)])) {
		[[_objForm delegate] form:_objForm didSelectFormItem:self];
	}
}

- (IBAction)textFieldDone:(id)sender {
    _activeField = false;
	_blnChangedFlag = true;

    [_txtField setText:[self value]];

	if ([_objForm selectedIndexPath] &&
		([_objForm selectedIndexPath].row == _objIndexPath.row)) {
		[_objForm setSelectedIndexPath:nil];
		
		[self keyboardWillHide:self];

        if (_blnDisplayMultiLineFlag) {
            // Instead of reloading the whole table (i.e. [_objForm redraw]), only update the selected row.
            // Reloading the whole table would resign the first responder causing the table to be redrawn with
            // no way of handling the user click.  Additionally, this needs to be done async so that the row does
            // not get deleted (reloading the row does an implicit row delete) while the UIControlEventEditingDidEnd
            // event is still running -- see the addition of the text field in getHeight for where the target is set up.
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *indexPaths = [NSArray arrayWithObject:_objIndexPath];
                [[_objForm tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            });
        }
	}
    
	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (CGFloat)getHeight {
	// Create UITextField if it has not yet been created
	// Configure events handling on it as well
	if (_txtField == nil) {
        _txtField = [[UITextField alloc] initWithFrame:[self getControlFrameWithHeight:0]];
        _txtField.tag = _intIndex;
        _txtField.clearsOnBeginEditing = NO;
        [_txtField addTarget:self
                      action:@selector(textFieldEdit:)
            forControlEvents:UIControlEventAllEditingEvents];
		[_txtField addTarget:self
					  action:@selector(textFieldStart:)
			forControlEvents:UIControlEventEditingDidBegin];
        [_txtField addTarget:self 
					  action:@selector(textFieldDone:) 
			forControlEvents:UIControlEventEditingDidEnd | UIControlEventEditingDidEndOnExit];
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
	_txtField.enabled = _blnEnabledFlag;

	// Update UILabel Properties (including Height)
	[_lblField setText:_strValue];
	CGRect objFrame = [_lblField frame];
	objFrame.size.height = 5000;
	[_lblField setFrame:objFrame];
	[QSLabels trimFrameHeightForLabel:_lblField];

	if (_blnHiddenFlag) {
		return 0;
	} else if (_blnDisplayMultiLineFlag) {
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

// This function will get called when the keyboard is going to be shown.  The main purpose of this function
// is to make sure that if the keyboard covers up a selected text field, the view will scroll so that it is
// visible.
//   NOTE: This majority of this function will only be used by iOS7 and greater since the contentOffset of scroll views
//         has changed from iOS6 to iOS7+.
- (void)keyboardWillShowNotification:(NSNotification *)notification {
    
    if (_activeField == false) {
        return;
    }
    
    // This function will only deal with a system version of iOS7 or greater.  iOS6 versions will
    // not use this function...Those versions will continue to use the older way of using the
    // (void)keyboardWillShow:(id)sender method.  This is due to the iOS6 and iOS7 contentOffset for
    // scrollviews being different.  If a version less than iOS7 is encountered, just return.
    NSString *reqSysVer = @"7";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] == NSOrderedAscending) {
        // we are not iOS7 or higher, just return.
        return;
    }
    
    if (_objForm.suspendScrollRestoreFlag) {
        [_objForm setSuspendScrollRestoreFlag:false];
        return;
    }
    
    UIScrollView * objScrollView = (UIScrollView *)[_objForm.navigatedViewController view];
    
    // Are we "already scrolling"?  If not, let's store the current ScrollView data
    if (!_TextFieldFormItem_blnIsScrollingFlag) {
        _TextFieldFormItem_objCurrentFrame = [objScrollView frame];
        _TextFieldFormItem_objCurrentContentSize = [objScrollView contentSize];
        _TextFieldFormItem_objCurrentContentOffset = [objScrollView contentOffset];
        _TextFieldFormItem_blnCurrentScrollEnableFlag = [objScrollView isScrollEnabled];
        _TextFieldFormItem_blnIsScrollingFlag = true;
    }
    _TextFieldFormItem_blnIsCleaningUpFlag = false;
    
    // Get the height of the keyboard to determine if the keyboard will cover the field we are editing.
    CGFloat fltKbHeight = [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    // Get the y-offset
    CGFloat fltYOffset = _TextFieldFormItem_objCurrentContentOffset.y;
    
    [UIView beginAnimations:@"" context:NULL];
    
    [[_objForm.navigatedViewController navigationItem] prompt];
    
    // Set the frame and size of the scroll view for when the keyboard appears.
    [objScrollView setFrame:CGRectMake(_TextFieldFormItem_objCurrentFrame.origin.x,
                                       _TextFieldFormItem_objCurrentFrame.origin.y,
                                       [UIScreen mainScreen].bounds.size.width,
                                       _TextFieldFormItem_objCurrentFrame.size.height - fltKbHeight)];
    [UIView commitAnimations];
    [objScrollView setScrollEnabled:true];
    [objScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,
                                             _TextFieldFormItem_objCurrentFrame.size.height + fltYOffset)];
    
    // Get the origin point of the selected item check if it is to create the area that should be visible
    CGPoint ptItemOrigin = [self->_txtField.superview convertPoint:self->_txtField.frame.origin toView:nil];
    CGFloat fltItemHeight = [[_objForm getFormItemAtIndex:[_objForm.selectedIndexPath row]] getHeight];
    
    // Scroll if the item selected is not in the current scrollview frame
    if (!CGRectContainsPoint(objScrollView.frame, ptItemOrigin) ) {
        CGRect objRectToScrollTo = CGRectMake(0,
                                              ptItemOrigin.y + fltYOffset,
                                              [UIScreen mainScreen].bounds.size.width,
                                              fltItemHeight);
    
        [objScrollView scrollRectToVisible:objRectToScrollTo animated:NO];
    }
}

// This method should only be called when running in iOS6.  iOS7+ uses notifications instead.
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

- (void)keyboardWillHideNotification:(NSNotification *)notification {
}

#pragma mark -
#pragma mark Object Lifecycle

- (void)dealloc {
	[self setValue:nil];
	[_lblField release];
	[_txtField release];
    
    // Remove the observers we created in initWithKey:.  The app will crash if we do not do this.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super dealloc];
}

@end
