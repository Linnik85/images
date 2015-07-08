//
//  ITImagesViewController.m
//  images
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import "ITImagesViewController.h"
#import "ITModelImages.h"
#import "ITImageTableViewCell.h"
#import "ITImageItem.h"
#import "UIImage+SCCropImageToCircleWithBorder.h"
#import "ITSettings.h"
#import "ITImagePresentViewController.h"
#import "SVProgressHUD.h"


@interface ITImagesViewController ()

@property(strong, nonatomic) NSMutableArray* imageItems;

@property(strong, nonatomic) ITSettings* settings;

@end

@implementation ITImagesViewController


#pragma mark - Lifecycle


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.imageItems = [NSMutableArray array];
    
    self.settings = [[ITSettings alloc]init];
    
    self.imageItems = self.settings.modelImages.items;
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.113 green:0.705 blue:0.919 alpha:1]];
    
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    
    if (!self.imageItems.count>0) {
        
        [SVProgressHUD show];

        self.tableView.separatorColor = [UIColor whiteColor];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(errorResponds:)
                                                 name:@"ErrorNotitfication"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateImageList:)
                                                 name:@"UpdateImageListNotitfication"
                                               object:nil];
    [self.settings.modelImages getImageList];
    
    [self.tableView reloadData];


    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ErrorNotitfication" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateImageListNotitfication" object:nil];


}


#pragma mark - Notification


-(void) updateImageList:(NSNotification*)notification{
    
    [SVProgressHUD dismiss];
    
    if ([[notification object] isKindOfClass:[NSMutableArray class]]) {
        
        self.imageItems = [notification object];
        
        self.tableView.separatorColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];

        [self.tableView reloadData];
        
    }
    
}

-(void) errorResponds:(NSNotification*)notification {
    
    [SVProgressHUD dismiss];
    
    if ([[notification object] isKindOfClass:[NSString class]]) {
        
        [SVProgressHUD showErrorWithStatus:[notification object]];
        

    }
}


#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.imageItems.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"imageCell";
    
    ITImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    ITImageItem* image = [self.imageItems objectAtIndex:indexPath.row];
    
    cell.idLabelOutlet.text = [NSString stringWithFormat: @"Image Id - %ld",(long)image.imageID];

    
    if (image.imagePreviewData.length>0) {
        
        cell.imageIconOutlet.image = [[UIImage imageWithData:image.imagePreviewData] cropToCircleWithBorderColor:[UIColor colorWithRed:0.113 green:0.705 blue:0.919 alpha:1] lineWidth:2];
        
    } else {
        
        UIImage* imageTemp = cell.imageIconOutlet.image;
        
        cell.imageIconOutlet.image = [imageTemp cropToCircleWithBorderColor:[UIColor colorWithRed:0.113 green:0.705 blue:0.919 alpha:1] lineWidth:8];
    }
    
    if (image.imageSize.length>0) {
        
        cell.sizeLabelOutlet.text = [NSString stringWithFormat:@"Size: %@", image.imageSize];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Segue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"imagePresent"]) {
        
        ITImagePresentViewController *controller = segue.destinationViewController;
        
        controller.settings = self.settings;
        
        ITImageItem* imageItem = [self.imageItems objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        controller.imageItem = imageItem;
        
    }
}


#pragma mark - Privet Methods


- (IBAction)refreshDataAction:(id)sender {
    
    self.imageItems = nil;
    
    [self.settings.modelImages clearCashe];
    
    self.tableView.separatorColor = [UIColor whiteColor];
    
    [self.tableView reloadData];


}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
