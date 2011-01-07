//
//  ListFormItem.h
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItem.h"

@interface ListFormItem : FormItem <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
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

@property (nonatomic, retain, getter=SingleValue, setter=SingleValue) NSString * _strSingleValue;
@property (nonatomic, assign, getter=AllowOtherFlag, setter=AllowOtherFlag) bool _blnAllowOtherFlag;
@property (nonatomic, assign, getter=DisplayMultiLineFlag, setter=DisplayMultiLineFlag) bool _blnDisplayMultiLineFlag;


- (ListFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel SingleValue:(NSString *)strSingleValue;
- (ListFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel MultipleValue:(NSArray *)strMultipleValueArray;

- (void)addItemWithName:(NSString *)strName;
- (void)addItemWithName:(NSString *)strName Value:(NSString *)strValue;
- (void)addItemWithName:(NSString *)strName IntegerValue:(NSInteger)intValue;
- (NSArray *)MultipleValueArray;
- (void)removeAllItems;

- (IBAction)backClick:(id)sender;
- (IBAction)textFieldDone:(id)sender;
@end