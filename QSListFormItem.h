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

@interface QSListFormItem : QSFormItem <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	NSString * _strSingleValue;

	NSMutableArray * _strMultipleValueArray;
	NSString * _strOtherValue;

	NSMutableArray * _strNameArray;
	NSMutableArray * _strValueArray;
	NSMutableArray * _blnSelectedArray;
	UITableViewController * _objTableViewController;

	bool _blnAllowOtherFlag;
	bool _blnMultipleSelectFlag;
	bool _blnDisplayMultiLineFlag;

	UIAlertView * _objAlertView;
	UILabel * _lblField;
}

@property (nonatomic, retain, getter=singleValue, setter=setSingleValue) NSString * _strSingleValue;
@property (nonatomic, assign, getter=allowOtherFlag, setter=setAllowOtherFlag) bool _blnAllowOtherFlag;
@property (nonatomic, assign, getter=displayMultiLineFlag, setter=setDisplayMultiLineFlag) bool _blnDisplayMultiLineFlag;


- (QSListFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel SingleValue:(NSString *)strSingleValue;
- (QSListFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel MultipleValue:(NSArray *)strMultipleValueArray;

- (void)addItemWithName:(NSString *)strName;
- (void)addItemWithName:(NSString *)strName Value:(NSString *)strValue;
- (void)addItemWithName:(NSString *)strName IntegerValue:(NSInteger)intValue;
- (NSArray *)multipleValueArray;
- (void)removeAllItems;

- (IBAction)backClick:(id)sender;
- (IBAction)textFieldDone:(id)sender;
@end