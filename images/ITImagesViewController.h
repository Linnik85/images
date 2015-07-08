//
//  ITImagesViewController.h
//  images
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITImagesViewController : UIViewController <UITableViewDataSource,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)refreshDataAction:(id)sender;


@end
