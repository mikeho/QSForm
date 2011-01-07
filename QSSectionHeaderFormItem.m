//
//  SectionHeaderFormItem.m
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import "SectionHeaderFormItem.h"
#import <UIKit/UITableView.h>
#include "Constants.h"

@implementation SectionHeaderFormItem

@synthesize _strText;

- (SectionHeaderFormItem *)initWithKey:(NSString *)strKey Text:(NSString *)strText {
	if (self = (SectionHeaderFormItem *)[super initWithKey:strKey Label:nil]) {
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
