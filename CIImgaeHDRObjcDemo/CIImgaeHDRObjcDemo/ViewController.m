//
//  ViewController.m
//  CIImgaeHDRObjcDemo
//
//  Created by 摩卡 on 2025/11/10.
//

#import "ViewController.h"
#import "CIMainViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CIMainViewController *viewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewController = CIMainViewController.new;
    [self.view addSubview:_viewController.view];
}


@end
