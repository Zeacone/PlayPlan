//
//  ViewController.m
//  PlayPlan
//
//  Created by Zeacone on 15/10/25.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface ViewController ()

@property (nonatomic) UITableView *tableview;
@property (nonatomic) NSMutableArray *mainArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadTableView];
}

- (void)loadTableView {
    self.tableview = ({
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height - 64)];
        tableview.backgroundColor = [UIColor clearColor];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview;
    });
    [self.view addSubview:self.tableview];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", nil];
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"4", @"5", @"6", nil];
    self.mainArray = [NSMutableArray arrayWithObjects:array1, array2, nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"Section = %@, row = %@", @(indexPath.section), @(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Section = %@, row = %@", @(indexPath.section), @(indexPath.row));
        [self.mainArray[indexPath.section] removeObjectAtIndex:indexPath.row];
        NSLog(@"Section = %@, row = %@", @(indexPath.section), @(indexPath.row));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
