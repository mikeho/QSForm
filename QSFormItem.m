/**
 * QSFormItem.m
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

#import "QSForm.h"
#import "QSControls.h"

@implementation QSFormItem

@synthesize _intIndex;
@synthesize _objIndexPath;
@synthesize _strKey;
@synthesize _strLabel;
@synthesize _objForm;
@synthesize _blnShortLabelFlag;
@synthesize _strSubscreenPrompt;
@synthesize _blnChangedFlag;
@synthesize _blnHiddenFlag;

- (QSFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel {
	if (self = [super init]) {
		_strKey = [strKey retain];
		_strLabel = [strLabel retain];
		_blnShortLabelFlag = false;
		_blnChangedFlag = false;
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	static NSString * strIdentifier = @"identifier";
    UITableViewCell * objCell;

	objCell = [objTableView dequeueReusableCellWithIdentifier:strIdentifier];

	// Create a New Cell (if none was dequeued)
    if (objCell == nil) {
		_blnCreatedFlag = true;
		objCell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:strIdentifier];
		[objCell autorelease];
		
		// Create the Label (if applicable)
		if (_strLabel != nil) {
			UILabel * lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelSideMargin, kLabelTopMargin, (_blnShortLabelFlag ? kShortLabelWidth : kLabelWidth), 100)];
			[lblLabel setLineBreakMode:UILineBreakModeWordWrap];
			[lblLabel setNumberOfLines:0];
			lblLabel.textAlignment = UITextAlignmentRight;
			lblLabel.tag = kDefaultLabelTag;
			lblLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:1.0];
			lblLabel.font = [UIFont boldSystemFontOfSize:11];
			lblLabel.text = _strLabel;
			[objCell.contentView addSubview:lblLabel];
			[QSLabels trimFrameHeightForLabel:lblLabel WithMinHeight:25];
			[lblLabel release];
		}
	} else {
		_blnCreatedFlag = false;
		UILabel * lblLabel = (UILabel *)[objCell.contentView viewWithTag:111];
		if (lblLabel) {
			lblLabel.text = _strLabel;
			[QSLabels trimFrameHeightForLabel:lblLabel WithMinHeight:25];
		}
	}

	[objCell setHidden:_blnHiddenFlag];
	return objCell;
}

- (CGFloat)getHeight {
	if (_blnHiddenFlag) return 0;

	UILabel * lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelSideMargin, kLabelTopMargin, (_blnShortLabelFlag ? kShortLabelWidth : kLabelWidth), 100)];
	[lblLabel setLineBreakMode:UILineBreakModeWordWrap];
	[lblLabel setNumberOfLines:0];
	lblLabel.textAlignment = UITextAlignmentRight;
	lblLabel.tag = kDefaultLabelTag;
	lblLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:1.0];
	lblLabel.font = [UIFont boldSystemFontOfSize:11];
	lblLabel.text = _strLabel;
	[QSLabels trimFrameHeightForLabel:lblLabel WithMinHeight:25];

	CGFloat fltToReturn = fmax(40, kLabelTopMargin + kLabelBottomMargin + lblLabel.bounds.size.height);
	[lblLabel release];
	return fltToReturn;
}

- (CGFloat)getControlWidth {
	return [UIScreen mainScreen].bounds.size.width - (kLabelSideMargin*4) - (_blnShortLabelFlag ? kShortLabelWidth : kLabelWidth) - kLabelGutterMargin;
}

- (CGRect)getControlFrameWithHeight:(CGFloat)fltHeight {
	if (fltHeight == 0) fltHeight = 25;
	CGRect objRect = CGRectMake((_blnShortLabelFlag ? kShortLabelWidth : kLabelWidth) + kLabelSideMargin + kLabelGutterMargin,
								kLabelTopMargin,
								[self getControlWidth],
								fltHeight);
	return objRect;
}

- (CGRect)getControlFrameWithWidth:(CGFloat)fltWidth Height:(CGFloat)fltHeight {
	if (fltHeight == 0) fltHeight = 25;
	CGRect objRect = CGRectMake((_blnShortLabelFlag ? kShortLabelWidth : kLabelWidth) + kLabelSideMargin + kLabelGutterMargin,
								kLabelTopMargin,
								fltWidth,
								fltHeight);
	return objRect;
}

- (CGRect)getControlFrameWithoutPaddingWithHeight:(CGFloat)fltHeight {
	if (fltHeight == 0) fltHeight = 25;
	CGRect objRect = CGRectMake((_blnShortLabelFlag ? kShortLabelWidth : kLabelWidth) + kLabelSideMargin + kLabelGutterMargin,
								kLabelTopMargin,
								[self getControlWidth] + kLabelSideMargin,
								fltHeight);
	return objRect;
}

- (void)setOnChangeTarget:(id)objTarget Action:(SEL)objAction {
	_objOnChangeAction = objAction;
	_objOnChangeTarget = objTarget;
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {
	/* By Default, Does Nothing */
	/* the Return value specifies whether or not the row is in a "selected" state */
	return false;
}

- (void)tableViewCellUnselect:(UITableViewCell *)objCell {
}

- (void)dealloc {
	[_strKey release];
	[_strLabel release];
	[_strSubscreenPrompt release];
	[_objIndexPath release];
	[super dealloc];
}

@end