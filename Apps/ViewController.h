//
//  ViewController.h
//  Apps
//
//  Created by Roman Kazmirchuk on 21.07.15.
//  Copyright (c) 2015 Roman Kazmirchuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property IBOutlet UITableView *tableView;

@end

