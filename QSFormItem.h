/**
 * QSFormItem.h
 * 
 * Copyright (c) 2010 - 2011, Quasidea Development, LLC
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
#import "QSFormViewController.h"
#define kDefaultLabelTag 111;
#define kShortLabelWidth 75
#define kLabelWidth 150
#define kLabelGutterMargin 10
#define kLabelTopMargin 10
#define kLabelBottomMargin 5
#define kLabelSideMargin 10

@interface QSFormItem : NSObject {
	NSInteger _intIndex;
	NSIndexPath * _objIndexPath;

	NSString * _strKey;
	NSString * _strLabel;

	bool _blnShortLabelFlag;

	bool _blnCreatedFlag;
	bool _blnChangedFlag;
	QSFormViewController * _objForm;
	bool _blnHiddenFlag;

	NSString * _strSubscreenPrompt;

	id _objOnChangeTarget;
	SEL _objOnChangeAction;
}

- (QSFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel;
- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView;
- (CGFloat)getHeight;
- (CGFloat)getControlWidth;

- (CGRect)getControlFrameWithHeight:(CGFloat)fltHeight;
- (CGRect)getControlFrameWithWidth:(CGFloat)fltWidth Height:(CGFloat)fltHeight;
- (CGRect)getControlFrameWithoutPaddingWithHeight:(CGFloat)fltHeight;

- (void)setOnChangeTarget:(id)objTarget Action:(SEL)objAction;

- (bool)tableViewCellTapped:(UITableViewCell *)objCell;
- (void)tableViewCellUnselect:(UITableViewCell *)objCell;

@property (nonatomic, assign, getter=Index, setter=Index) NSInteger _intIndex;
@property (nonatomic, retain, getter=IndexPath, setter=IndexPath) NSIndexPath * _objIndexPath;
@property (nonatomic, retain, getter=Key, setter=Key) NSString * _strKey;
@property (nonatomic, retain, getter=Label, setter=Label) NSString * _strLabel;
@property (nonatomic, retain, getter=Form, setter=Form) QSFormViewController * _objForm;
@property (nonatomic, assign, getter=ShortLabelFlag, setter=ShortLabelFlag) bool _blnShortLabelFlag;
@property (nonatomic, retain, getter=SubscreenPrompt, setter=SubscreenPrompt) NSString * _strSubscreenPrompt;
@property (nonatomic, assign, getter=ChangedFlag) bool _blnChangedFlag;
@property (nonatomic, assign, getter=HiddenFlag, setter=HiddenFlag) bool _blnHiddenFlag;

@end
