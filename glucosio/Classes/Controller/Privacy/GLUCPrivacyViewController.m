//
//  GLUCPrivacyViewController.m
//  glucosio
//
//  Created by Eugenio Baglieri on 18/02/16.
//  Copyright © 2016 Glucosio.org. All rights reserved.
//

#import "GLUCPrivacyViewController.h"

@interface GLUCPrivacyViewController ()

@end

@implementation GLUCPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allowLinks = NO;
}

- (NSURL *)url {
    return [NSURL URLWithString:kGLUCPrivacyUrlString];
}

@end
