//
//  TextFieldFormItem.h
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItem.h"

@interface TextFieldFormItem : FormItem {
	NSString * _strValue;
	bool _blnPasswordFlag;
	UITextAutocorrectionType _intAutocorrectionType;
	UITextAutocapitalizationType _intAutocapitalizationType;
}

@property (nonatomic, retain, getter=Value, setter=Value) NSString * _strValue;
@property (nonatomic, assign, getter=PasswordFlag, setter=PasswordFlag) bool _blnPasswordFlag;
@property (nonatomic, assign, getter=AutocorrectionType, setter=AutocorrectionType) UITextAutocorrectionType _intAutocorrectionType;
@property (nonatomic, assign, getter=AutocapitalizationType, setter=AutocapitalizationType) UITextAutocapitalizationType _intAutocapitalizationType;

- (TextFieldFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(NSString *)strValue;
- (IBAction)textFieldDone:(id)sender;
- (IBAction)textFieldStart:(id)sender;
@end