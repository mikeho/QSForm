/**
 * QSSectionHeaderFormItem.m
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

@implementation QSSectionHeaderFormItem

@synthesize _strText;

- (QSSectionHeaderFormItem *)initWithKey:(NSString *)strKey Text:(NSString *)strText {
	if (self = (QSSectionHeaderFormItem *)[super initWithKey:strKey Label:nil]) {
		_strText = strText;
		[_strText retain];
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	UILabel * lblText;

	if (_blnCreatedFlag) {
		lblText = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, 15, [UIScreen mainScreen].bounds.size.width - 2*kSideMargin, 25)];
		[lblText setTag:_intIndex];
		[objCell addSubview:lblText];
    } else {
		lblText = (UILabel *)[objCell viewWithTag:_intIndex];
	}

	[objCell setBackgroundColor:[UIColor clearColor]];

	[lblText setText:_strText];
	[lblText setTextColor:[UIColor whiteColor]];
	[lblText setShadowColor:[UIColor darkGrayColor]];
	[lblText setShadowOffset:CGSizeMake(1, 1)];
	[lblText setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:1.0]];
	[lblText setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
	[lblText setTextAlignment:UITextAlignmentCenter];

	return objCell;
}

- (CGFloat)getHeight {
	return 40;
}

- (void)dealloc {
	[_strText release];
	[super dealloc];
}

@end
