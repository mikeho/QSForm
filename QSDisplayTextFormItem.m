//
//  DisplayTextFormItem.m
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import "DisplayTextFormItem.h"
#import <UIKit/UITableView.h>
#include "Constants.h"

@implementation DisplayTextFormItem

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
