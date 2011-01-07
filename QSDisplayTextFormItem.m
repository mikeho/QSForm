/**
 * QSDisplayTextFormItem.m
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

@implementation QSDisplayTextFormItem

@synthesize _strText;

- (DisplayTextFormItem *)initWithKey:(NSString *)strKey Text:(NSString *)strText {
	if (self = (DisplayTextFormItem *)[super initWithKey:strKey Label:nil]) {
		[self Text:strText];
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	[objCell setBackgroundColor:[UIColor clearColor]];
	if (_strText != nil) {
		[[objCell textLabel] setText:[NSString stringWithFormat:@"\n%@", _strText]];
		[[objCell textLabel] setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
		[[objCell textLabel] setNumberOfLines:0];
		[[objCell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
	}

	return objCell;
}

- (CGFloat)getHeight {
	if (_strText == nil) return kTopMargin;

	return fmax(40, [[NSString stringWithFormat:@"\n%@", _strText] sizeWithFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]
															  constrainedToSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - kSideMargin*4), 100)
																  lineBreakMode:UILineBreakModeWordWrap].height) + kLabelTopMargin*1.5;
}

- (void)dealloc {
	[self Text:nil];
	[super dealloc];
}

@end
