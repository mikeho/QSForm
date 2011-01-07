//
//  DateTimeFormItem.h
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItem.h"

@interface DateTimeFormItem : FormItem <UIActionSheetDelegate> {
	NSDate * _dttValue;
	NSString * _strDateTimeFormat;
	bool _blnTimeFlag;
	
	UIDatePicker * _objPicker;
}

@property (nonatomic, retain, getter=Value, setter=Value) NSDate * _dttValue;
@property (nonatomic, assign, getter=TimeFlag, setter=TimeFlag) bool _blnTimeFlag;
@property (nonatomic, retain, getter=DateTimeFormat, setter=DateTimeFormat) NSString * _strDateTimeFormat;

- (DateTimeFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(NSDate *)dttValue;
@end