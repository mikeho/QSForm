/**
 * QSImageCaptureFormItem.m
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

#import <UIKit/UITableView.h>
#import "QSForm.h"

@implementation QSImageCaptureFormItem

@synthesize _objImage;

- (ImageCaptureFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Image:(UIImage *)objImage {
	if (self = (ImageCaptureFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_objImage = objImage;
		[_objImage retain];
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	// Setup Trash Icon
	if (_imgTrash == nil) {
		_imgTrash = [UIButton buttonWithType:UIButtonTypeCustom];
		[_imgTrash retain];
		[_imgTrash setFrame:CGRectMake(55, 35, 22, 28)];
		[_imgTrash setBackgroundImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
	}

	[objCell addSubview:_imgTrash];
	[_imgTrash removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
	[_imgTrash addTarget:self action:@selector(eraseClick:) forControlEvents:UIControlEventTouchUpInside];

	if (_imgView != nil) {
		[[objCell contentView] addSubview:_imgView];
		[_imgTrash setHidden:false];
	} else {
		UILabel * lblInfo = [[UILabel alloc] initWithFrame:[self getControlFrameWithHeight:25]];
		[lblInfo setTag:_intIndex];
		[lblInfo setText:@"Tap to Access Camera"];
		[lblInfo setTextColor:[UIColor grayColor]];
		[lblInfo setFont:[UIFont italicSystemFontOfSize:[UIFont systemFontSize]]];
		[[objCell contentView] addSubview:lblInfo];
		
		[lblInfo release];
		[_imgTrash setHidden:true];
	}

	return objCell;
}

- (void)eraseClick:(id)sender {
	[self Image:nil];
	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (CGFloat)getHeight {
	if (_imgView != nil) {
		[_imgView removeFromSuperview];
		[_imgView release];
		_imgView = nil;
	}

	if (_objImage) {
		CGFloat fltWidth = [self getControlWidth];
		CGFloat fltHeight = fltWidth * [_objImage size].height / [_objImage size].width;
		CGRect objRect = CGRectMake((_blnShortLabelFlag ? kShortLabelWidth : kLabelWidth) + kLabelSideMargin + kLabelGutterMargin,
									kLabelTopMargin,
									fltWidth,
									fltHeight);

		_imgView = [[UIImageView alloc] initWithFrame:objRect];
		[_imgView setImage:_objImage];
		[_imgView setUserInteractionEnabled:false];

		return fltHeight + 2*kLabelTopMargin;
	} else {
		return 40;
	}
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {
	UIImagePickerController * objImagePicker = [[UIImagePickerController alloc] init];

	[objImagePicker setDelegate:self];
	[objImagePicker setAllowsEditing:false];
	[objImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];

	[[_objForm NavigatedViewController] presentModalViewController:objImagePicker animated:true];
	[objImagePicker autorelease];
	return false;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self Image:(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]];
    [[picker parentViewController] dismissModalViewControllerAnimated:true];
	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[picker parentViewController] dismissModalViewControllerAnimated:true];
}

- (void)dealloc {
	[self Image:nil];
	[_imgView release];
	[_imgTrash release];
	[super dealloc];
}

@end
