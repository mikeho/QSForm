/**
 * QSListFormItem.h
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

#import <Foundation/Foundation.h>
#import "QSFormItem.h"

@interface QSNameFormItem : QSFormItem <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	int _intIdValue;
	NSString * _strNameValue;

	NSMutableArray * _arrNameArrayByLetter;
	NSMutableArray * _arrIdArrayByLetter;

	UITableViewController * _objTableViewController;
	UIView * _objTableHeaderView;

	UILabel * _lblField;
}

@property (nonatomic, assign, getter=idValue, setter=idValue:) int _intIdValue;
@property (nonatomic, retain, getter=tableHeaderView, setter=setTableHeaderView:) UIView * _objTableHeaderView;

- (QSNameFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel IdValue:(int)intIdValue;

- (void)removeAllNames;
- (void)refreshTableView;
- (void)addItemWithFirstName:(NSString *)strFirstName lastName:(NSString *)strLastName idValue:(int)idValue;

- (CGFloat)refreshImageView;

- (IBAction)backClick:(id)sender;
@end