//
//  PRMonogram.h
//  persona-example
//
//  Created by Leptos on 7/30/18.
//  Copyright © 2018 Leptos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRMonogram : NSObject

@property (nonatomic, copy) NSString *text;
@property (assign, nonatomic) NSUInteger fontIndex;
@property (nonatomic, retain) UIColor *color;

+ (instancetype)monogram;
+ (instancetype)monogramWithData:(NSData *)data;

+ (NSArray<UIColor *> *)monogramColors;

/**** font info ****/
+ (NSUInteger)countOfFonts;
+ (UIFont *)fontForIndex:(NSUInteger)index plateDiameter:(CGFloat)diameter;
+ (CGFloat)kerningForFontIndex:(NSUInteger)index fontSize:(CGFloat)size;

+ (CAGradientLayer *)plateOverlayLayer;
+ (UIColor *)plateFlatColor;

- (void)setFontIndexToUnsupportedValue;

- (NSData *)dataRepresentation;

// options not yet implemented, pass nil
- (UIImage *)snapshotWithSize:(CGSize)size scale:(CGFloat)scale options:(id)options;
- (UIImage *)snapshotWithOptions:(id)options;

@end
