//
//  TLViewController.m
//  TLProgressSpring
//
//  Created by Andrew on 05/17/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

#import "TLViewController.h"
#import <TLProgressSpring/TLNavBarProgressView.h>
#import "TLNavController.h"
#import "TLCircleProgressController.h"
#import "TLActivityIndicatorController.h"
#import "TLOverlayController.h"
#import "TLNetworkController.h"

@interface TLViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *arrayData;
@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"进度条的各种效果";
    self.view.backgroundColor=[UIColor whiteColor];
    
    _arrayData=@[@"导航栏进度条",
                 @"网络请求进度条",
                 @"轮子一直转",
                 @"带有百分比的进度条",
                 @"带遮罩效果的进度条"];
    
    
    
    [self initTableview];
}

-(void)initTableview{
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVHEIGHT)];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];

}



#pragma mark UITableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellId=@"cellIdentity";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];

    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text=_arrayData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            TLNavController *navController = [[TLNavController alloc]init];
            [self.navigationController pushViewController:navController animated:YES];
        }
            break;
        case 1:
        {
            TLNetworkController *networkVc=[[TLNetworkController alloc]init];
            [self.navigationController pushViewController:networkVc animated:YES];
        }
            break;
        case 2:
        {
            TLActivityIndicatorController *vc=[[TLActivityIndicatorController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            TLCircleProgressController *circle=[[TLCircleProgressController alloc]init];
            [self.navigationController pushViewController:circle animated:YES];
        }
            break;
        
        case 4:
        {
            TLOverlayController *overlay=[[TLOverlayController alloc]init];
            [self.navigationController pushViewController:overlay animated:YES];
        }
            break;
            
        default:
            break;
    }
}




@end
