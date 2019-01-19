//
//  LSViewController.m
//  persona-example
//
//  Created by Leptos on 7/30/18.
//  Copyright © 2018 Leptos. All rights reserved.
//

#import "LSViewController.h"

#import "../../PersonaUI/PRMonogram.h"
#import "../../PersonaUI/PRLikenessView.h"

@implementation LSViewController {
    PRLikenessView *_likenessView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *loadErr = nil;
    NSBundle *personaKit = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/PersonaKit.framework"];
    if (![personaKit loadAndReturnError:&loadErr]) {
        NSLog(@"%@", loadErr);
        return;
    }
    
    NSBundle *personaUI = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/PersonaUI.framework"];
    if (![personaUI loadAndReturnError:&loadErr]) {
        NSLog(@"%@", loadErr);
        return;
    }
    
    PRMonogram *monogram = [NSClassFromString(@"PRMonogram") monogram];
    monogram.text = @"LS";
    monogram.color = UIColor.orangeColor;
    monogram.fontIndex = 0;
    
    PRLikeness *likeness = [self _likenessForRecipe:[monogram dataRepresentation]];
    
    PRLikenessView *likenessView = [[NSClassFromString(@"PRLikenessView") alloc] initWithLikeness:likeness];
    UIView *holdingView = self.monogramHoldingView;
    likenessView.frame = holdingView.bounds;
    likenessView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [holdingView addSubview:likenessView];
    
    _likenessView = likenessView;
    
    self.monogramDescriptorLabel.text = [self _fontNameForFontIndex:monogram.fontIndex];
}

- (NSString *)_fontNameForFontIndex:(NSUInteger)fontIndex {
    UIFont *currentFont = [NSClassFromString(@"PRMonogram") fontForIndex:fontIndex plateDiameter:CGRectGetWidth(_likenessView.frame)];
    /* docs for -[UIFont fontName]: "The value in this property is intended for an application’s internal usage only and should not be displayed."
     * is there a value that is intended to be displayed? UIFont.fontDescriptor.postscriptName doesn't seem different
     */
    return [NSString stringWithFormat:@"%@ - %@", [@(fontIndex) descriptionWithLocale:NSLocale.currentLocale], currentFont.fontName];
}

- (PRLikeness *)_likenessForRecipe:(NSData *)recipe {
    return [NSClassFromString(@"PRLikeness") monogramWithScope:PRLikenessScopePrivate recipe:recipe staticRepresentation:NULL];
}

- (IBAction)monogramSwipe:(UISwipeGestureRecognizer *)sender {
    PRMonogram *monogram = [NSClassFromString(@"PRMonogram") monogramWithData:_likenessView.likeness.recipe];
    NSInteger currentIndex = monogram.fontIndex; /* signed, so that -1 doesn't underflow */
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        case UISwipeGestureRecognizerDirectionUp:
        case (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionUp):
            currentIndex++;
            break;
        case UISwipeGestureRecognizerDirectionRight:
        case UISwipeGestureRecognizerDirectionDown:
        case (UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionDown):
            currentIndex--;
            break;
    }
    NSInteger maxValue = [NSClassFromString(@"PRMonogram") countOfFonts] - 1;
    if (currentIndex < 0) {
        currentIndex = maxValue;
    } else if (currentIndex > maxValue) {
        currentIndex = 0;
    }
    monogram.fontIndex = currentIndex;
    
    self.monogramDescriptorLabel.text = [self _fontNameForFontIndex:monogram.fontIndex];
    
    _likenessView.likeness = [self _likenessForRecipe:[monogram dataRepresentation]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setNeedsStatusBarAppearanceUpdate {
    [super setNeedsStatusBarAppearanceUpdate];
    
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.prefersStatusBarHidden;
}

@end
