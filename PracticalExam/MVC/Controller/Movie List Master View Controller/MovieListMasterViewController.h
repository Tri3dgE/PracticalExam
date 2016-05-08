//
//  MovieListMasterViewController.h
//  PracticalExam
//
//  Created by Mel Bryan Villegas on 5/6/16.
//  Copyright (c) 2016 Mel Bryan Villegas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"


#define movieImageDataURL @"https://dl.dropboxusercontent.com/u/5624850/movielist/images/"



@class MovieDetailsViewController;

@interface MovieListMasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    BOOL firstLoad;
}

@property (strong, nonatomic) MovieDetailsViewController *detailViewController;

//Property variable that will be used to contain the data-source to be read by the View Controller Table View
@property (strong, nonatomic) __block NSMutableArray *movieDataDictionaryArray;

@property (weak, nonatomic) IBOutlet UITableView *movieListTableView;


@end
