//
//  TLOverlayController.m
//  TLProgressSpring
//
//  Created by Andrew on 16/5/18.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLOverlayController.h"
#import <TLProgressSpring/TLOverlayProgressView.h>

@interface TLOverlayController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *arrayData;

@end

@implementation TLOverlayController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    _arrayData=@[@"显示普通转轮",
                 @"TLOverlayStyleIcon",
                 @"TLOverlayStyleCheckmark",
                 @"TLOverlayStyleHorizontalBar",
                 @"TLOverlayStyleIndeterminateSmall",
                 @"TLOverlayStyleDeterminateCircular"];
    [self initTable];
    
}

-(UIView *)rootView{
    return self.view.window;
}

-(void)initTable{
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVHEIGHT)];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.textLabel.text=_arrayData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    TLOverlayStyle style;
    switch (indexPath.row) {
        case 0:
        {
            style=TLOverlayStyleIndeterminate;
        }
            break;
            
        case 1:
            style=TLOverlayStyleIcon;
            break;
        case 2:
            style=TLOverlayStyleCheckmark;
            break;
        case 3:
            style=TLOverlayStyleHorizontalBar;
            break;

        case 4:
            style=TLOverlayStyleIndeterminateSmall;
            break;

        case 5:
            style=TLOverlayStyleDeterminateCircular;
            break;

        default:
        {
            style=TLOverlayStyleIndeterminate;
        }
            break;
    }
    
    [self onShowProgress4:style];
}

#pragma mark 工厂方法
- (void)onShowIndeterminateProgressView:(id)sender {
    TLOverlayProgressView *progressView = [TLOverlayProgressView showOverlayAddTo:self.view
                                                                             title:@"加载中..."
                                                                             style:TLOverlayStyleIndeterminate animated:YES stopBlock:^(TLOverlayProgressView *progressView) {
                                                                                 [progressView hideAnimated:YES];
                                                                             }];
    [self.view addSubview:progressView];
    [progressView showAnimated:YES];
    
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}


-(void)onShowProgress2{

}
-(void)onShowProgress3{
    
}
-(void)onShowProgress4:(TLOverlayStyle )style{
    TLOverlayProgressView *progress = [TLOverlayProgressView showOverlayAddTo:self.view
                                                                        title:@""
                                                                        style:style
                                                                     animated:YES];
    [self performBlock:^{
        [progress dismiss:YES];
    } afterDelay:2.0];
    
    
}
-(void)onShowProgress5{
    
}
-(void)onShowProgress6{
    
}
-(void)onShowProgress7{
    
}


- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
