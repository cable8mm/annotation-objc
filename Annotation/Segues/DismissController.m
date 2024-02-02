//
//  DismissController.m
//  Annotation
//
//  Created by 이삼구 on 11/02/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import "DismissController.h"

@implementation DismissController

- (void)perform
{
    UIViewController *sourceVC = self.sourceViewController;
    [sourceVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
