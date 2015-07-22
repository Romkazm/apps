//
//  ViewController.m
//  Apps
//
//  Created by Roman Kazmirchuk on 21.07.15.
//  Copyright (c) 2015 Roman Kazmirchuk. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface ViewController ()

@property NSArray *apps;
@property NSMutableArray *filteredApps;

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
        
        self.filteredApps = [NSMutableArray arrayWithArray:self.apps];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
        NSLog(@"%@", error);
        
    }];

}

- (void)filterAppsWithString:(NSString *)string {

    self.filteredApps = [NSMutableArray array];
    
    for (int i = 0; i < [self.apps count]; i++) {
    
        NSString *appTitle = [[[self.apps objectAtIndex:i] objectForKey:@"title"] objectForKey:@"label"];
        if ([appTitle rangeOfString:string].location != NSNotFound) {
        
            [self.filteredApps addObject:[self.apps objectAtIndex:i]];
        
        }
    
    }

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.filteredApps count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell"];
    
    if (!cell) {
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppCell"];
    
    }
    
    NSDictionary *app = [self.filteredApps objectAtIndex:indexPath.row];
    NSString *appTitle = [[app objectForKey:@"title"] objectForKey:@"label"];
    NSURL *imageURL = [NSURL URLWithString:[[[app objectForKey:@"im:image"] objectAtIndex:2] objectForKey:@"label"]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@", [self.apps indexOfObject:app] + 1, appTitle];
    [cell.imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;

}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

    [searchBar setShowsCancelButton:YES animated:YES];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.filteredApps = [NSMutableArray arrayWithArray:self.apps];
    [self.tableView reloadData];

}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self filterAppsWithString:searchBar.text];
    [self.tableView reloadData];

}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    [self filterAppsWithString:searchText];
    [self.tableView reloadData];

}

@end














