//
//  ImageCaptureFormItem.m
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import "ImageCaptureFormItem.h"
#import <UIKit/UITableView.h>

@implementation ImageCaptureFormItem

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
