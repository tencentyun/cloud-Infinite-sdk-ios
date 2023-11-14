//
//  TPGViewController.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2023/3/3.
//  Copyright © 2023 garenwang. All rights reserved.
//

#import "TPGViewController.h"
#import "ViewController.h"
#import "GetAveColorVC.h"
#import "CIZoomImageVC.h"
#import "CICutImageVC.h"
#import "CIFormatVC.h"
#import "CISigmaVC.h"
#import "CIQualityChangeVC.h"
#import "CIWaterMarkVC.h"
#import "CIStripImageVC.h"
#import "CISharpenVC.h"
#import "CIGifOptimizeVC.h"
#import "CIRoTateVC.h"
#import "CIImageListTestVC.h"
#import "CIDecodeVC.h"

@interface TPGViewController ()
@property (nonatomic,strong)NSArray <NSString *> * titleArray;
@end

@implementation TPGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TPG解码器";
    self.titleArray = @[@"SDWebImage加载TPG图片",@"解码测试",@"图片列表展示"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld:%@",indexPath.row + 1,self.titleArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc;
    
    if (indexPath.row == 0) {
        
        vc = [mainSB instantiateViewControllerWithIdentifier:@"ViewController"];
        ViewController * tempVC = (ViewController *)vc;
        tempVC.format = CIImageTypeTPG;
    }
    
    if(indexPath.row == 1){
        CIDecodeVC * decodeVC = [[CIDecodeVC alloc]initWithNibName:@"BaseViewController" bundle:nil];
        decodeVC.format = CIImageTypeTPG;
        vc = decodeVC;
    }
    
    if (indexPath.row == 2) {
        vc = [CIImageListTestVC new];
        ((CIImageListTestVC *)vc).format = CIImageTypeTPG;
    }
    
    vc.title = self.titleArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
