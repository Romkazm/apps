//
//  ViewController.m
//  Apps
//
//  Created by Roman Kazmirchuk on 21.07.15.
//  Copyright (c) 2015 Roman Kazmirchuk. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@property NSArray *apps;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self downloadApps];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refreshControl addTarget:self action:@selector(refreshApps:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshApps:(UIRefreshControl *)refreshControl {

    [self downloadApps];
    [refreshControl endRefreshing];

}

- (void)downloadApps {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    static NSString *url = @"https://itunes.apple.com/us/rss/toppaidapplications/limit=100/json";
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        self.apps = [[responseObject objectForKey:@"feed"] objectForKey:@"entry"];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@", error);
        
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.apps count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell"];
    
    if (!cell) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppCell"];
    
    }
    
//    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@", indexPath.row + 1, [[[self.apps objectAtIndex:indexPath.row] objectForKey:@"title"] objectForKey:@"label"]];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[self.apps objectAtIndex:indexPath.row] objectForKey:@"im:image"] objectAtIndex:2] objectForKey:@"label"]]]];
    
    return cell;

}

@end
