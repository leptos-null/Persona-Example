//
//  ViewController.m
//  persona-example
//
//  Created by Leptos on 7/30/18.
//  Copyright © 2018 Leptos. All rights reserved.
//

#import "LSViewController.h"

#import "PRMonogram.h"
#import "PRLikenessView.h"

@implementation LSViewController

/**
 @brief Serializer for PRMonogram, reverse engineered from -[PRMonogram dataRepresentation]
 @param text The text to be presented within the monogram, must be less than 16 characters
 @param color The color of the background of the monogram (this is completely unimplemented as of iOS 10.2)
 @param fontIndex The index of the font to use, see the "font info" section of the PRMonogram header
 @return Data that can be used with +[PRMonogram monogramWithData:] or +[PRLikeness monogramWithRecipe:staticRepresentation:]
 @throws NSInvalidArgumentException if text.length is greater than 16 or if fontIndex is out of bounds
 */
static NSData *monogramRecipeFromComponents(NSString *text, UIColor *color, NSUInteger fontIndex) {
    /* these exceptions are not in the original code
     * they're added here to avoid undefined behavior
     */
    if (fontIndex >= PRMonogram.countOfFonts) {
        NSString *exceptionReason = @"fontIndex may not be greater than or equal to PRMonogram.countOfFonts";
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:exceptionReason userInfo:NULL];
    }
    
    const char *textBytes = text.UTF8String;
    size_t textLength = strlen(textBytes);
    const uint8_t lowByteMax = 0xf;
    
    if (textLength > lowByteMax) {
        NSString *exceptionReason = @"text.length must be less than 16";
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:exceptionReason userInfo:NULL];
    }
    
    NSMutableData *recipe = [NSMutableData data];
    
    const uint8_t nullByte = 0;
    [recipe appendBytes:&nullByte length:1];
    
    /* magic byte usage
     * high bytes: textLength
     * low bytes: fontIndex
     */
    uint8_t magicByte = (textLength << 4) | (fontIndex & lowByteMax);
    [recipe appendBytes:&magicByte length:1];
    
    [recipe appendBytes:textBytes length:textLength];
    
    const NSUInteger colorComponents = 4;
    CGFloat colors[colorComponents];
    [color getRed:&colors[0] green:&colors[1] blue:&colors[2] alpha:&colors[3]];
    [recipe appendBytes:colors length:colorComponents];
    
    return recipe;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSData *recipe = monogramRecipeFromComponents(@"LS", UIColor.orangeColor, 0);
    
    /* the other option is to create a monogram and then get the data */
    PRMonogram *monogram = [PRMonogram monogram];
    monogram.text = @"LS";
    monogram.color = UIColor.orangeColor;
    monogram.fontIndex = 0;
    /* NSData *recipe = */ [monogram dataRepresentation];
    
    PRLikeness *likeness = [PRLikeness monogramWithScope:PRLikenessScopePrivate recipe:recipe staticRepresentation:NULL];
    
    PRLikenessView *likenessView = [[PRLikenessView alloc] initWithLikeness:likeness];
    UIView *holdingView = self.monogramHoldingView;
    likenessView.frame = holdingView.bounds;
    likenessView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [holdingView addSubview:likenessView];
}

@end
