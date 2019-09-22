//
//  SelectCityViewController.m
//  Runner
//
//  Created by liwanchun on 2019/9/21.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "SelectCityViewController.h"
#import "CitySelectMangager.h"
@interface SelectCityViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(strong,nonatomic)NSMutableArray*proviceArray;
@property(strong,nonatomic)NSMutableArray*cityArray;
@property(strong,nonatomic)NSMutableArray*areaArray;

@property(strong,nonatomic)NSDictionary*provice;
@property(strong,nonatomic)NSDictionary*city;
@property(strong,nonatomic)NSDictionary*area;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[CitySelectMangager shard] saveCityDB];
    [[CitySelectMangager shard] openDb];
 
    self.provice = [NSDictionary dictionary];
     self.city = [NSDictionary dictionary];
     self.area = [NSDictionary dictionary];
    
    self.proviceArray = [NSMutableArray array];
    self.cityArray = [NSMutableArray array];
    self.areaArray = [NSMutableArray array];
    
    NSArray* array =  [[CitySelectMangager shard] queryData:@"000000"];
    [self.proviceArray addObjectsFromArray:array];
    
    if(array.count>0){
        NSDictionary*dic = array[0];
        self.provice = dic;
        NSArray* cityArray =  [[CitySelectMangager shard] queryData:dic[@"code"]];
        [self.cityArray addObjectsFromArray:cityArray];
        
        if(cityArray.count>0){
            NSDictionary*dic = cityArray[0];
            self.city = dic;
            NSArray* areaArray =  [[CitySelectMangager shard] queryData:dic[@"code"]];
            [self.areaArray addObjectsFromArray:areaArray];
            if (self.areaArray.count>0) {
                self.area = self.areaArray[0];
            }
        }
    }
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    // Do any additional setup after loading the view.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
     return 3;
}
//行中有几列
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return self.proviceArray.count;
        case 1:
            return self.cityArray.count;
        case 2:
            return self.areaArray.count;
        default:
            break;
    }
    
     return 0 ;
}
//列显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.proviceArray[row][@"name"];
        case 1:
            return self.cityArray[row][@"name"];
        case 2:
            return self.areaArray[row][@"name"];
        default:
            break;
    }
    
    return @"";
}


- (IBAction)dissmiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sureAction:(id)sender {
    NSMutableArray*citys = [NSMutableArray array];
    [citys addObject:self.provice];
    [citys addObject:self.city];
    [citys addObject:self.area];
    self.returnTextBlock(citys);
     [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            {
                NSDictionary*dic = self.proviceArray[row];
                NSArray* cityArray =  [[CitySelectMangager shard] queryData:dic[@"code"]];
                [self.cityArray removeAllObjects];
                [self.cityArray addObjectsFromArray:cityArray];
               
                self.provice = dic;
                self.city = [NSDictionary dictionary];
                self.area = [NSDictionary dictionary];
               
                [pickerView reloadComponent:1];
                if (self.cityArray>0) {
                    [pickerView selectRow:0 inComponent:1 animated:YES];
                    
                    NSDictionary*dic = self.cityArray[0];
                     self.city = dic;
                    NSArray* areaArray =  [[CitySelectMangager shard] queryData:dic[@"code"]];
                    [self.areaArray removeAllObjects];
                    [self.areaArray addObjectsFromArray:areaArray];
                    
                    
                    [pickerView reloadComponent:2];
                    if(self.areaArray.count>0){
                        self.area = self.areaArray[0];
                        [pickerView selectRow:0 inComponent:2 animated:YES];
                    }
                }
            }
            break;
        case 1:
            {
                
                NSDictionary*dic = self.cityArray[row];
                self.city = dic;
                self.area = [NSDictionary dictionary];
                NSArray* areaArray =  [[CitySelectMangager shard] queryData:dic[@"code"]];
                [self.areaArray removeAllObjects];
                [self.areaArray addObjectsFromArray:areaArray];
               
               
                [pickerView reloadComponent:2];
                if(self.areaArray.count>0){
                    self.area = self.areaArray[0];
                    [pickerView selectRow:0 inComponent:2 animated:YES];
                }else{
                  self.area = [NSDictionary dictionary];
                }
            }
             break;
        case 2:
        {
             NSDictionary*dic = self.areaArray[row];
             self.area = dic;
        }
            
//            return self.areaArray[row][@"name"];
        default:
            break;
    }
}


@end
