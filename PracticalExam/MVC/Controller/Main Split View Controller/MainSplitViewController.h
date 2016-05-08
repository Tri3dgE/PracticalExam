//
//  MainSplitViewController.h
//  PracticalExam
//
//  Created by Mel Bryan Villegas on 5/5/16.
//  Copyright (c) 2016 Mel Bryan Villegas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

#define movieMetaDataURL @"https://dl.dropboxusercontent.com/u/5624850/movielist/list_movies_page1.json"


@interface MainSplitViewController : UISplitViewController <UISplitViewControllerDelegate, UIAlertViewDelegate>
{
    
    AFHTTPSessionManager *movieDataDownloadManager;
    
    NSTimer *movieDataDownloadTimer;
}
    

@end
