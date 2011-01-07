//
//  DisplayTextFormItem.h
//  iVQ
//
//  Created by Mike Ho on 9/23/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormItem.h"

@interface DisplayTextFormItem : FormItem {
	NSString * _strText;
}

@property (nonatomic, retain, getter=Text, setter=Text) NSString * _strText;

- (DisplayTextFormItem *)initWithKey:(NSString *)strKey Text:(NSString *)strText;
@end