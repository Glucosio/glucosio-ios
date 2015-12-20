//
//  GLUCIndexedListViewController.h
//  glucosio
//
//  Created by Eugenio Baglieri on 18/12/15.
//  Copyright © 2015 Glucosio.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLUCEditorViewController.h"

@interface GLUCIndexedListEditorViewController : GLUCEditorViewController

@property (strong, nonatomic, readwrite) NSArray *items;
@property (assign, nonatomic) NSUInteger selectedItemIndex;

- (IBAction)save:(UIButton *)sender;

@end
