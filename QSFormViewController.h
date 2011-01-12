/**
 * QSFormViewController.h
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

#import <UIKit/UIKit.h>
@class QSFormItem;

@interface QSFormViewController : UITableViewController {
	NSMutableArray * _objFormItemArray;
	UIViewController * _objNavigatedViewController;
	NSString * _strHeaderText;
	NSIndexPath * _objSelectedIndexPath;
	bool _blnMakeAllLabelsShortFlag;
	
	CGRect _objCurrentFrame;
	CGSize _objCurrentContentSize;
	CGPoint _objCurrentContentOffset;
	bool _blnCurrentScrollEnableFlag;
	bool _blnSuspendScrollRestoreFlag;
}

@property (nonatomic, retain, getter=navigatedViewController, setter=setNavigatedViewController) UIViewController * _objNavigatedViewController;
@property (nonatomic, retain, getter=headerText, setter=setHeaderText) NSString * _strHeaderText;
@property (nonatomic, retain, getter=selectedIndexPath, setter=setSelectedIndexPath) NSIndexPath * _objSelectedIndexPath;
@property (nonatomic, assign, getter=makeAllLabelsShortFlag, setter=setMakeAllLabelsShortFlag) bool _blnMakeAllLabelsShortFlag;

- (QSFormViewController *)initAtTop:(NSInteger)intTop NavigatedViewController:(UIViewController *)objNavigatedViewController;
- (QSFormItem *)addFormItem:(QSFormItem *)objItem;
- (QSFormItem *)getFormItemWithKey:(NSString *)strKey;
- (QSFormItem *)getFormItemAtIndex:(NSInteger)intIndex;
- (void)removeAllFormItems;
- (void)redraw;

- (CGFloat)adjustHeightToFit;
- (CGFloat)getHeight;
- (CGFloat)getYPositionForCellAtIndexPath:(NSIndexPath *)objIndexPath;

- (void)keyboardWillShow:(id)sender;
- (void)resetScrolling;
- (void)keyboardWillHide:(id)sender;

- (void)unselectTableCells;
@end