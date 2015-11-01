/**
 * QSTextFieldFormItem.h
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

@interface QSTextFieldFormItem : QSFormItem {
	NSString * _strValue;
	bool _blnPasswordFlag;
	bool _blnDisplayMultiLineFlag;
	UITextAutocorrectionType _intAutocorrectionType;
	UITextAutocapitalizationType _intAutocapitalizationType;
	UIKeyboardType _intKeyboardType;
    bool _activeField;
	
	UITextField * _txtField;
	UILabel * _lblField;
}

@property (nonatomic, retain, getter=value, setter=setValue:) NSString * _strValue;
@property (nonatomic, assign, getter=passwordFlag, setter=setPasswordFlag:) bool _blnPasswordFlag;
@property (nonatomic, assign, getter=displayMultiLineFlag, setter=setDisplayMultiLineFlag:) bool _blnDisplayMultiLineFlag;
@property (nonatomic, assign, getter=autocorrectionType, setter=setAutocorrectionType:) UITextAutocorrectionType _intAutocorrectionType;
@property (nonatomic, assign, getter=autocapitalizationType, setter=setAutocapitalizationType:) UITextAutocapitalizationType _intAutocapitalizationType;
@property (nonatomic, assign, getter=keyboardType, setter=setKeyboardType:) UIKeyboardType _intKeyboardType;
@property (nonatomic, assign, getter=activeField, setter=setActiveField:) bool _activeField;

- (QSTextFieldFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Value:(NSString *)strValue;
- (IBAction)textFieldDone:(id)sender;
- (IBAction)textFieldStart:(id)sender;

- (void)keyboardWillHide:(id)sender;
- (void)resetScrollingStep1;
- (void)resetScrollingStep2;
- (void)keyboardWillShow:(id)sender;

- (void)keyboardWillShowNotification:(NSNotification *)notification;
- (void)keyboardWillHideNotification:(NSNotification *)notification;
@end