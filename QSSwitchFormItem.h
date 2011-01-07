//
//  SwitchFormItem.h
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItem.h"

@interface SwitchFormItem : FormItem {
	bool _blnValue;
	bool _blnValueExists;
	NSString * _strOverrideOnLabel;
	NSString * _strOverrideOffLabel;
}

@property (nonatomic, assign, getter=Value, setter=Value) bool _blnValue;
@property (nonatomic, assign, getter=ValueExists) bool _blnValueExists;
@property (nonatomic, retain, getter=OverrideOnLabel, setter=OverrideOnLabel) NSString * _strOverrideOnLabel;
@property (nonatomic, retain, getter=OverrideOffLabel, setter=OverrideOffLabel) NSString * _strOverrideOffLabel;

- (IBAction)chkFieldTap:(id)sender;
- (IBAction)unansweredClick:(id)sender;

- (SwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(bool)blnValue;
- (SwitchFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel WithNullValue:(id)objNull;

@end
