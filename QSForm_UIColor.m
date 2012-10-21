#import "QSForm_UIColor.h"

@implementation UIColor (UITableViewBackground)

+ (UIColor *)groupTableViewBackgroundColor
{
    return [UIColor colorWithRed:185.0f/255.0f green:192.0f/255.0f blue:202.0f/255.0f alpha:1.0f];
//    __strong static UIImage* tableViewBackgroundImage = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(7.f, 1.f), NO, 0.0);
//        CGContextRef c = UIGraphicsGetCurrentContext();
//        [[self colorWithRed:185/255.f green:192/255.f blue:202/255.f alpha:1.f] setFill];
//        CGContextFillRect(c, CGRectMake(0, 0, 4, 1));
//        [[self colorWithRed:185/255.f green:193/255.f blue:200/255.f alpha:1.f] setFill];
//        CGContextFillRect(c, CGRectMake(4, 0, 1, 1));
//        [[self colorWithRed:192/255.f green:200/255.f blue:207/255.f alpha:1.f] setFill];
//        CGContextFillRect(c, CGRectMake(5, 0, 2, 1));
//        tableViewBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
//        [tableViewBackgroundImage retain];
//        UIGraphicsEndImageContext();
//    });
//    return [self colorWithPatternImage:tableViewBackgroundImage];
}

@end