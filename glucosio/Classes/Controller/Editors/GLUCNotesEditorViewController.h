//
//  GLUCNotesEditorViewController.h
//  glucosio
//
//  Created by Chris Walters on 2/17/18.
//  Copyright © 2018 Glucosio.org. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "GLUCModel.h"

@interface GLUCNotesEditorViewController : XLFormViewController

@property (strong, nonatomic, readwrite) GLUCModel *editedObject;
@property (strong, nonatomic) NSString *editedProperty;

@end
