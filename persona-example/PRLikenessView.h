//
//  PRLikenessView.h
//  persona-example
//
//  Created by Leptos on 7/30/18.
//  Copyright © 2018 Leptos. All rights reserved.
//

#import "PRLikeness.h"

@interface PRLikenessView : UIView

@property (assign, getter=isCircular, nonatomic) BOOL circular;
@property (assign, nonatomic) BOOL highlighted;
@property (assign, nonatomic) BOOL shouldDecode;
@property (nonatomic, retain) PRLikeness *likeness;

- (instancetype)initWithLikeness:(PRLikeness *)likeness;

- (void)setNeedsRedraw;

@end
