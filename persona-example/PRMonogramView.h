//
//  PRMonogramView.h
//  persona-example
//
//  Created by Leptos on 7/30/18.
//  Copyright © 2018 Leptos. All rights reserved.
//

#import "PRMonogram.h"

@interface PRMonogramView : UIView <UITextFieldDelegate>

@property (nonatomic, retain) PRMonogram *monogram;

@property (assign, getter=isCircular, nonatomic) BOOL circular;
@property (assign, getter=isSelected, nonatomic) BOOL selected;

@property (assign, nonatomic) BOOL bordered;
@property (assign, nonatomic) BOOL highlighted;
@property (assign, nonatomic) BOOL allowsEditing;

- (void)textFieldResignFirstResponder;

@end
