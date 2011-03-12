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

- (QSImageCaptureFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Image:(UIImage *)objImage {
	if (self = (QSImageCaptureFormItem *)[super initWithKey:strKey Label:strLabel]) {
		_objImage = objImage;
		[_objImage retain];
	}
	return self;
}

- (UITableViewCell *)getUITableViewCellForUITableView:(UITableView *)objTableView {
	UITableViewCell * objCell = [super getUITableViewCellForUITableView:objTableView];

	[self refreshImageView];
	if ([[objCell subviews] indexOfObject:_imgView] == NSNotFound) {
		[[objCell contentView] addSubview:_imgView];
		[[objCell contentView] addSubview:_lblTapHere];
		[[objCell contentView] addSubview:_imgTrash];
	}

	[_imgTrash removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
	[_imgTrash addTarget:self action:@selector(eraseClick:) forControlEvents:UIControlEventTouchUpInside];

	return objCell;
}

- (CGFloat)refreshImageView {
	// Setup Trash Icon
	if (_imgTrash == nil) {
		_imgTrash = [UIButton buttonWithType:UIButtonTypeCustom];
		[_imgTrash retain];
		[_imgTrash setFrame:CGRectMake(55, 35, 22, 28)];
		[_imgTrash setBackgroundImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
	}

	if (_imgView == nil) {
		_imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[_imgView setUserInteractionEnabled:false];
	}
	
	if (_lblTapHere == nil) {
		_lblTapHere = [[UILabel alloc] initWithFrame:[self getControlFrameWithHeight:25]];
		[_lblTapHere setText:@"Tap to Access Camera"];
		[_lblTapHere setTextColor:[UIColor grayColor]];
		[_lblTapHere setFont:[UIFont italicSystemFontOfSize:[UIFont systemFontSize]]];
	}
	
	// Image?
	if (_objImage) {
		[_lblTapHere setHidden:true];
		[_imgTrash setHidden:false];
		[_imgView setHidden:false];
		
		CGFloat fltWidth = [self getControlWidth];
		CGFloat fltHeight = fltWidth * [_objImage size].height / [_objImage size].width;
		CGRect objRect = CGRectMake((_blnShortLabelFlag ? kShortLabelWidth : kLabelWidth) + kLabelSideMargin + kLabelGutterMargin,
									kLabelTopMargin,
									fltWidth,
									fltHeight);
		[_imgView setFrame:objRect];
		[_imgView setImage:_objImage];
		
		return fltHeight + 2*kLabelTopMargin;

	// No Image
	} else {
		[_lblTapHere setHidden:false];
		[_imgTrash setHidden:true];
		[_imgView setHidden:true];
		
		[_imgView setImage:nil];
		return 40.0f;
	}
}

- (void)eraseClick:(id)sender {
	[self setImage:nil];
	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (CGFloat)getHeight {
	return [self refreshImageView];
}

- (bool)tableViewCellTapped:(UITableViewCell *)objCell {	
	UIImagePickerController * objImagePicker = [[UIImagePickerController alloc] init];

	[objImagePicker setDelegate:self];
	[objImagePicker setAllowsEditing:false];
	
	if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
		// Has camera
		[objImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
	} else {
		[objImagePicker setSourceType: UIImagePickerControllerSourceTypeSavedPhotosAlbum];
	}

	[[_objForm navigatedViewController] presentModalViewController:objImagePicker animated:true];
	[objImagePicker autorelease];
	return false;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self setImage:(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]];
    [[picker parentViewController] dismissModalViewControllerAnimated:true];
	if (_objOnChangeTarget) [_objOnChangeTarget performSelector:_objOnChangeAction withObject:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[picker parentViewController] dismissModalViewControllerAnimated:true];
}

- (void)dealloc {
	[self setImage:nil];
	[_imgView release];
	[_imgTrash release];
	[_lblTapHere release];
	[super dealloc];
}

@end
