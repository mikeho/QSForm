/**
 * QSFormItem.h
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
@class QSFormViewController;

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

@property (nonatomic, assign, getter=index, setter=setIndex) NSInteger _intIndex;
@property (nonatomic, retain, getter=indexPath, setter=setIndexPath) NSIndexPath * _objIndexPath;
@property (nonatomic, retain, getter=key, setter=setKey) NSString * _strKey;
@property (nonatomic, retain, getter=label, setter=setLabel) NSString * _strLabel;
@property (nonatomic, retain, getter=form, setter=setForm) QSFormViewController * _objForm;
@property (nonatomic, assign, getter=shortLabelFlag, setter=setShortLabelFlag) bool _blnShortLabelFlag;
@property (nonatomic, retain, getter=subscreenPrompt, setter=setSubscreenPrompt) NSString * _strSubscreenPrompt;
@property (nonatomic, assign, getter=changedFlag) bool _blnChangedFlag;
@property (nonatomic, assign, getter=hiddenFlag, setter=setHiddenFlag) bool _blnHiddenFlag;

@end
