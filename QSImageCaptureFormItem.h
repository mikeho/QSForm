//
//  ImageCaptureFormItem.h
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItem.h"

@interface ImageCaptureFormItem : FormItem <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	// Public Property
	UIImage * _objImage;

	// Used Internally
	UIImageView * _imgView;
	UIButton * _imgTrash;
}

@property (nonatomic, retain, getter=Image, setter=Image) UIImage * _objImage;

- (ImageCaptureFormItem *)initWithKey:(NSString *)strKey Label:(NSString *)strLabel Image:(UIImage *)objImage;
- (void)eraseClick:(id)sender;
@end