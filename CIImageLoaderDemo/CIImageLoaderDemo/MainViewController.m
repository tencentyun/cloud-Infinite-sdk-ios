//
//  MainViewController.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2023/3/3.
//  Copyright © 2023 garenwang. All rights reserved.
//

#import "MainViewController.h"
#import "RootViewController.h"
#import "TPGViewController.h"
#import "AVIFViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"万象优图";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)toAvif:(UIButton *)sender {
    [self.navigationController pushViewController:[AVIFViewController new] animated:YES];
}
- (IBAction)toTpg:(UIButton *)sender {
    [self.navigationController pushViewController:[TPGViewController new] animated:YES];
}
- (IBAction)toBasic:(UIButton *)sender {
    
    [self.navigationController pushViewController:[RootViewController new] animated:YES];
    
}

@end
