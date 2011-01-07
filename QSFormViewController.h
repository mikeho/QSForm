//
//  FormViewController.h
//  iVQ
//
//  Created by Mike Ho on 9/22/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FormItem;

@interface FormViewController : UITableViewController {
	NSMutableArray * _objFormItemArray;
	UIViewController * _objNavigatedViewController;
	NSString * _strHeaderText;
	NSIndexPath * _objSelectedIndexPath;
	bool _blnSetAllLabelsShortFlag;
	
	CGRect _objCurrentFrame;
	CGSize _objCurrentContentSize;
	CGPoint _objCurrentContentOffset;
	bool _blnCurrentScrollEnableFlag;
	bool _blnSuspendScrollRestoreFlag;
}

@property (nonatomic, retain, getter=NavigatedViewController, setter=NavigatedViewController) UIViewController * _objNavigatedViewController;
@property (nonatomic, retain, getter=HeaderText, setter=HeaderText) NSString * _strHeaderText;
@property (nonatomic, retain, getter=SelectedIndexPath, setter=SelectedIndexPath) NSIndexPath * _objSelectedIndexPath;
@property (nonatomic, assign, getter=SetAllLabelsShortFlag, setter=SetAllLabelsShortFlag) bool _blnSetAllLabelsShortFlag;

- (FormViewController *)initAtTop:(NSInteger)intTop NavigatedViewController:(UIViewController *)objNavigatedViewController;
- (FormItem *)addFormItem:(FormItem *)objItem;
- (FormItem *)getFormItemWithKey:(NSString *)strKey;
- (FormItem *)getFormItemAtIndex:(NSInteger)intIndex;
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